package com.cropknowledge.model;

import java.time.LocalDateTime;

public final class SearchRecord {
    public final long id;
    public final String queryText;
    public final int resultCount;
    public final LocalDateTime createdAt;

    public SearchRecord(long id, String queryText, int resultCount, LocalDateTime createdAt) {
        this.id = id;
        this.queryText = queryText;
        this.resultCount = resultCount;
        this.createdAt = createdAt;
    }
}
