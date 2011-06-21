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

import java.util.List;

import org.apache.log4j.Logger;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class DiscoveryServiceTest {
    private DiscoveryService discoveryService = null;

    @Before
    public void setup() {
        discoveryService = new DiscoveryService();
    }

    @Test
    public void discoverClasses() {
        List<Class<?>> coreClasses = discoveryService.discoverClasses(this.getClass().getPackage().getName());
        Assert.assertFalse(coreClasses.isEmpty());
        Assert.assertTrue(coreClasses.contains(this.getClass()));
    }

    @Test
    public void discoverClassesInJar() {
        Assert.assertTrue(Logger.class.getProtectionDomain().getCodeSource().getLocation().toString().endsWith(".jar"));
        List<Class<?>> userModelClasses = discoveryService.discoverClasses(Logger.class.getPackage().getName());
        Assert.assertFalse(userModelClasses.isEmpty());
        Assert.assertTrue(userModelClasses.contains(Logger.class));
    }
}
