package com.cropknowledge.web;

public final class Html {
    private Html() { }

    public static String escape(Object value) {
        if (value == null) return "";
        String text = value.toString();
        return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            .replace("\"", "&quot;").replace("'", "&#39;");
    }
}
