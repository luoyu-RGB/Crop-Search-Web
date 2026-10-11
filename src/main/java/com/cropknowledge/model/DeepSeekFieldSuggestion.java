package com.cropknowledge.model;

public final class DeepSeekFieldSuggestion {
    private final String rawResponse;
    private final int sourcePage;
    public DeepSeekFieldSuggestion(String rawResponse, int sourcePage) { this.rawResponse=rawResponse; this.sourcePage=sourcePage; }
    public String getRawResponse() { return rawResponse; }
    public int getSourcePage() { return sourcePage; }
    public boolean isReviewRequired() { return true; }
}
