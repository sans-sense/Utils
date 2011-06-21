/*
 * Copyright (c) 2011 Imaginea Technologies Private Ltd. 
 * Hyderabad, India
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following condition
 * is met:
 *
 *     + Neither the name of Imaginea, nor the
 *       names of its contributors may be used to endorse or promote
 *       products derived from this software.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package com.imaginea.brightest.util;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

/**
 * Simple implementation to discover classes in the classpath matching given package name
 * 
 * @author apurba
 */
public class DiscoveryService {
    List<Resolver> classResolvers = new ArrayList<Resolver>();

    public DiscoveryService() {
        registerResolvers();
    }

    /**
     * Main entry point
     * 
     * @param packageName package name in dot notation i.e com.imaginea.brightest
     * @return
     */
    public List<Class<?>> discoverClasses(String packageName) {
        String classPath = System.getProperty("java.class.path");
        String[] pathElements = classPath.split(File.pathSeparator);
        List<Class<?>> discoveredClasses = new ArrayList<Class<?>>();
        for (String pathElement : pathElements) {
            discoveredClasses.addAll(getClasses(pathElement, packageName));
        }
        return discoveredClasses;
    }

    /**
     * Gets the classes for the given path and package
     * 
     * @param pathElement location under which to search
     * @param packageName package which to search
     * @return collection of classes that were found at the given location with the given package name
     */
    private Collection<? extends Class<?>> getClasses(String pathElement, String packageName) {
        List<Class<?>> discoveredClasses = new ArrayList<Class<?>>();
        for (Resolver classResolver : classResolvers) {
            discoveredClasses.addAll(classResolver.getClasses(pathElement, packageName));
        }
        return discoveredClasses;
    }

    /**
     * Internal method to register the resolvers used to handle jar and folder
     */
    private void registerResolvers() {
        classResolvers.add(new JarResolver());
        classResolvers.add(new FolderResolver());
    }

    /**
     * Base class for all resolvers. Resolvers know how to find classes in their type of resource.
     * 
     * @author apurba
     */
    private static abstract class Resolver {
        protected abstract boolean canResolve(String pathElement);

        protected abstract List<Class<?>> getClassesWithFilter(String pathElement, String packageName);

        public List<Class<?>> getClasses(String pathElement, String packageName) {
            if (canResolve(pathElement)) {
                return getClassesWithFilter(pathElement, packageName);
            } else {
                return Collections.<Class<?>> emptyList();
            }
        }
    }

    /**
     * A resolver that understands jar
     * 
     * @author apurba
     */
    private static class JarResolver extends Resolver {
        protected boolean canResolve(String pathElement) {
            return pathElement.endsWith(".jar");
        }

        public List<Class<?>> getClassesWithFilter(String file, String packageName) {
            packageName = packageName.replaceAll("\\.", "/"); // hard coding the file separator as in jar entries
                                                              // irrespective of OS it will always be this way
            List<Class<?>> classList = new ArrayList<Class<?>>();
            JarFile jarFile = null;
            try {
                jarFile = new JarFile(file);
                for (Enumeration<JarEntry> enumLis = jarFile.entries(); enumLis.hasMoreElements();) {
                    JarEntry currEntry = enumLis.nextElement();
                    if (currEntry.getName().startsWith(packageName) && currEntry.getName().endsWith(".class")) {
                        String qualifiedClassName = getClassName(currEntry.getName());
                        try {
                            classList.add(Class.forName(qualifiedClassName));
                        } catch (NoClassDefFoundError e) {
                            // this is a crazy class, so ignore this with just logging
                            System.err.println("Could not load " + qualifiedClassName);
                        } catch (UnsatisfiedLinkError e) {
                            // this is a crazy class, so ignore this with just logging
                            System.err.println("Could not load " + qualifiedClassName);
                        }
                    }
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            } catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            } finally {
                if (jarFile != null) {
                    try {
                        jarFile.close();
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            }
            return classList;
        }

        private String getClassName(String entryName) {
            String qualifiedClassName = entryName.replaceAll("/", ".");
            qualifiedClassName = qualifiedClassName.substring(0, qualifiedClassName.indexOf(".class"));
            return qualifiedClassName;
        }
    }

    /**
     * Resolver that understands folders
     * 
     * @author apurba
     */
    private static class FolderResolver extends Resolver {
        protected boolean canResolve(String pathElement) {
            return new File(pathElement).isDirectory();
        }

        public List<Class<?>> getClassesWithFilter(String pathElement, String packageName) {
            packageName = packageName.replaceAll("\\.", File.separator);
            List<Class<?>> classList = new ArrayList<Class<?>>();
            File rootFolder = new File(pathElement);
            RecursiveFinder finder = new RecursiveFinder(packageName);
            rootFolder.listFiles(finder);
            for (File file : finder.files) {
                String classFileName = file.getAbsolutePath().substring(pathElement.length());
                String qualifiedClassName = getClassName(classFileName);
                try {
                    classList.add(Class.forName(qualifiedClassName));
                } catch (ClassNotFoundException e) {
                    throw new RuntimeException(e);
                }
            }
            return classList;
        }

        private String getClassName(String classFileName) {
            String qualifiedClassName = classFileName.substring(1).replaceAll(File.separator, ".");
            qualifiedClassName = qualifiedClassName.substring(0, qualifiedClassName.indexOf(".class"));
            return qualifiedClassName;
        }
    }

    /**
     * A simple finder that collects all files that match its acceptance condition. This is stateful and does heavy
     * recursion.
     * 
     * @author apurba
     */
    private static class RecursiveFinder implements FileFilter {
        private final List<File> files = new ArrayList<File>();
        private final String packageName;

        private RecursiveFinder(String packageName) {
            this.packageName = packageName;
        }

        @Override
        public boolean accept(File childFile) {
            if (childFile.isDirectory()) {
                childFile.listFiles(this);
            } else if (childFile.getName().endsWith(".class")) {
                String absolutePath = childFile.getAbsolutePath();
                if (absolutePath.contains(packageName)) {
                    files.add(childFile);
                }
            }
            return false;
        }
    }
}
