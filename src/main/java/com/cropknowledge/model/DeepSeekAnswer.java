package com.cropknowledge.model;

import java.util.Collections;
import java.util.List;

public final class DeepSeekAnswer {
    private final String text;
    private final long cropId;
    private final int sourcePage;
    private final boolean databaseUsed;
    private final List<WebSource> webSources;
    public DeepSeekAnswer(String text, long cropId, int sourcePage) { this(text, cropId, sourcePage, cropId > 0); }
    public DeepSeekAnswer(String text, long cropId, int sourcePage, boolean databaseUsed) {
        this(text, cropId, sourcePage, databaseUsed, Collections.<WebSource>emptyList());
    }
    public DeepSeekAnswer(String text, long cropId, int sourcePage, boolean databaseUsed, List<WebSource> webSources) {
        this.text=text; this.cropId=cropId; this.sourcePage=sourcePage; this.databaseUsed=databaseUsed;
        this.webSources=Collections.unmodifiableList(new java.util.ArrayList<>(webSources));
    }
    public String getText() { return text; }
    public long getCropId() { return cropId; }
    public int getSourcePage() { return sourcePage; }
    public boolean isDatabaseUsed() { return databaseUsed; }
    public List<WebSource> getWebSources() { return webSources; }
    public String getHistoryText() {
        if (webSources.isEmpty()) return text;
        StringBuilder history = new StringBuilder(text).append("\n网络来源：");
        for (WebSource source : webSources) history.append("\n").append(source.getTitle()).append("：").append(source.getUrl());
        return history.toString();
    }
}
