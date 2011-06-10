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

import java.util.HashMap;
import java.util.Map;

/**
 * @author apurba
 */
public class OptionParser {
    private final Option<?>[] options;
    private final Map<Character, Option<?>> shortSymbolMap = new HashMap<Character, OptionParser.Option<?>>();
    private final Map<String, Option<?>> longSymbolMap = new HashMap<String, OptionParser.Option<?>>();

    public OptionParser(Option<?>... options) {
        this.options = options;
        for (Option<?> option : options) {
            shortSymbolMap.put(option.shortSymbol, option);
            longSymbolMap.put(option.longSymbol, option);
        }
    }

    public Option<?>[] parse(String[] args) {
        Option<?> currOption = null;
        for (int i = 0; i < args.length; i++) {
            String arg = args[i];
            if (currOption == null) {
                currOption = lookupOption(currOption, arg);
                if (currOption.dataType == OptionDataType.BOOLEAN) {
                    currOption.setValue(Boolean.TRUE);
                    if (args.length > (i + 1)) {
                        String nextArg = args[i + 1];
                        if (!isValidOptionStart(nextArg)) {
                            i = i + 1;
                            currOption.setValue(Boolean.parseBoolean(nextArg));
                        }
                    }
                    currOption = null;
                }
            } else {
                Object value = null;
                switch (currOption.dataType) {
                    case BOOLEAN:
                        value = Boolean.parseBoolean(arg);
                        break;
                    case INTEGER:
                        value = Integer.parseInt(arg);
                        break;
                    case STRING:
                        value = arg;
                        break;
                    default:
                        throw new IllegalArgumentException("Unknown type");
                }
                currOption.setValue(value);
                currOption = null;
            }
        }
        return options;
    }

    private boolean isValidOptionStart(String arg) {
        return (arg.startsWith("-") || (arg.startsWith("--")));
    }

    private Option<?> lookupOption(Option<?> currOption, String arg) {
        if (arg.startsWith("-")) {
            currOption = shortSymbolMap.get(arg.charAt(1));
        } else if (arg.startsWith("--")) {
            currOption = longSymbolMap.get(arg.substring(2));
        } else {
            throw new IllegalOptionException(arg);
        }
        return currOption;
    }

    public static class IllegalOptionException extends RuntimeException {
        private static final long serialVersionUID = -1146709722041398660L;

        public IllegalOptionException(String arg) {
            super("No option found for argument " + arg);
        }
    }

    public static enum OptionDataType {
        BOOLEAN, INTEGER, STRING;
    }

    public static class Option<T> {
        private OptionDataType dataType;
        private char shortSymbol;
        private String longSymbol;
        private T value;
        private boolean required = false;
        private T defaultValue;

        public Option(OptionDataType dataType, char shortSymbol, String longSymbol) {
            this.dataType = dataType;
            this.shortSymbol = shortSymbol;
            this.longSymbol = longSymbol;
        }

        public Option(OptionDataType dataType, char shortSymbol, String longSymbol, boolean required, T defaultValue) {
            this(dataType, shortSymbol, longSymbol);
            this.required = required;
            this.defaultValue = defaultValue;
        }

        public char getShortSymbol() {
            return shortSymbol;
        }

        public Option<T> setShortSymbol(char shortSymbol) {
            this.shortSymbol = shortSymbol;
            return this;
        }

        public String getLongSymbol() {
            return longSymbol;
        }

        public Option<T> setLongSymbol(String longSymbol) {
            this.longSymbol = longSymbol;
            return this;
        }

        public T getValue() {
            return value;
        }

        @SuppressWarnings("unchecked")
        public Option<T> setValue(Object value) {
            this.value = (T) value;
            return this;
        }

        public boolean isRequired() {
            return required;
        }

        public Option<T> setRequired(boolean required) {
            this.required = required;
            return this;
        }

        public T getDefaultValue() {
            return defaultValue;
        }

        public Option<T> setDefaultValue(T defaultValue) {
            this.defaultValue = defaultValue;
            return this;
        }

        public String toString() {
            return String.format("Option[ %s , %s]", longSymbol, value);
        }
    }
}
