package com.cropknowledge.model;

import java.util.List;

public class CropPage {
    public final List<Crop> crops;
    public final int page;
    public final int pageSize;
    public final int total;

    public CropPage(List<Crop> crops, int page, int pageSize, int total) {
        this.crops = crops;
        this.page = page;
        this.pageSize = pageSize;
        this.total = total;
    }

    public int pageCount() { return Math.max(1, (total + pageSize - 1) / pageSize); }
}
