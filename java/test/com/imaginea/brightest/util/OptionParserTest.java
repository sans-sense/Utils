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

import org.junit.Assert;
import org.junit.Test;

import com.imaginea.brightest.util.OptionParser.Option;
import com.imaginea.brightest.util.OptionParser.OptionDataType;

/**
 * Tests for simple options like "-f", "-f -c 20" etc
 * 
 * @author apurba
 */
public class OptionParserTest {
    @Test
    public void booleanParse() {
        Option<Boolean> force = new Option<Boolean>(OptionDataType.BOOLEAN, 'f', "force", false, false);
        OptionParser parser = new OptionParser(force);
        parser.parse(new String[] { "-f" });
        Assert.assertTrue(force.getValue());
    }

    @Test
    public void multipleOptionParse() {
        Option<Boolean> force = new Option<Boolean>(OptionDataType.BOOLEAN, 'f', "force", false, false);
        Option<Integer> count = new Option<Integer>(OptionDataType.INTEGER, 'c', "count", true, 20);
        OptionParser parser = new OptionParser(force, count);
        parser.parse(new String[] { "-f", "-c", "20" });
        Assert.assertTrue(force.getValue());
        Assert.assertTrue(20 == count.getValue());
    }

    @Test
    public void multipleOptionParseExplicitBoolean() {
        Option<Boolean> force = new Option<Boolean>(OptionDataType.BOOLEAN, 'f', "force", false, false);
        Option<Integer> count = new Option<Integer>(OptionDataType.INTEGER, 'c', "count", true, 20);
        OptionParser parser = new OptionParser(force, count);
        parser.parse(new String[] { "-f", "true", "-c", "20" });
        Assert.assertTrue(force.getValue());
        Assert.assertTrue(20 == count.getValue());
    }

    @Test
    public void multipleOptionParseBooleanFalse() {
        Option<Boolean> force = new Option<Boolean>(OptionDataType.BOOLEAN, 'f', "force", false, false);
        Option<Integer> count = new Option<Integer>(OptionDataType.INTEGER, 'c', "count", true, 20);
        OptionParser parser = new OptionParser(force, count);
        parser.parse(new String[] { "-f", "false", "-c", "20" });
        Assert.assertFalse(force.getValue());
        Assert.assertTrue(20 == count.getValue());
    }
}
