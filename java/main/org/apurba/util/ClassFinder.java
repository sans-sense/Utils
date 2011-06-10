/*
 * Created on Apr 16, 2005
 *
 */
package org.apurba.util;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.Enumeration;
import java.util.jar.JarFile;
import java.util.zip.ZipEntry;

/**
 * Iterates through all the jars in a given directory and finds the class
 * 
 * @author Apurba
 */
public class ClassFinder {
    private static String DIR_NAME = "/host/projects/brightest/brightest/sandbox/";
    private static String CLASS_NAME = "org.openqa.selenium.remote.server.rest.ResultConfig";
    private static String className = "jms";

    public static void main(String[] args) throws IOException {
        System.out.println("class searched for " + CLASS_NAME);
        className = CLASS_NAME.replaceAll("\\.", "/") + ".class";
        findClass(new File(DIR_NAME));
    }

    public static void findClass(File file) throws IOException {
        boolean jarNamePrinted = false;
        if (file.isDirectory()) {
            File[] files = file.listFiles(new FileFilter() {
                public boolean accept(File currFile) {
                    String fileName = currFile.getName();
                    return (fileName.indexOf(".jar") != -1 || fileName.indexOf(".zip") != -1 || currFile.isDirectory());
                }
            });
            if (files == null) {
                System.out.println("Problems reading " + file.getName());
            } else {
                for (int i = 0; i < files.length; i++) {
                    findClass(files[i]);
                }
            }
        } else {
            try {
                JarFile jarFile = new JarFile(file);
                for (Enumeration enumLis = jarFile.entries(); enumLis.hasMoreElements();) {
                    ZipEntry currEntry = (ZipEntry) enumLis.nextElement();
                    if (currEntry.getName().indexOf(className) != -1) {
                        if (!jarNamePrinted) {
                            System.out.println("Found in jar file " + file.getAbsolutePath());
                            System.out.println("<classpathentry kind=\"lib\" path=\"" + file.getAbsolutePath() + "\" />");
                            jarNamePrinted = true;
                        }
                        System.out.println("Complete class qualifier " + currEntry.getName());
                    }
                }
            } catch (Exception e) {
            }
        }
    }
}
