package com.cropknowledge.model;

public final class DeepSeekAnswer {
    private final String text;
    private final long cropId;
    private final int sourcePage;
    public DeepSeekAnswer(String text, long cropId, int sourcePage) { this.text=text; this.cropId=cropId; this.sourcePage=sourcePage; }
    public String getText() { return text; }
    public long getCropId() { return cropId; }
    public int getSourcePage() { return sourcePage; }
}
