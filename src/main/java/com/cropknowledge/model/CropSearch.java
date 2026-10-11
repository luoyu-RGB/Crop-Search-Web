package com.cropknowledge.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CropSearch {
    public String name;
    public String family;
    public String genus;
    public String features;
    public String distribution;
    public String cultivation;
    public String uses;
    public final List<TextFilter> textFilters = new ArrayList<>();
    public BigDecimal minOil;
    public BigDecimal maxOil;
    public BigDecimal minIodine;
    public BigDecimal maxIodine;
    public BigDecimal minAcid;
    public BigDecimal maxAcid;
    public BigDecimal minSaponification;
    public BigDecimal maxSaponification;
    public String component;
    public BigDecimal minComponent;
    public BigDecimal maxComponent;
    public boolean matchAny;
    public boolean includePending;
    public int page = 1;

    public boolean hasComponentCondition() {
        return component != null && !component.isEmpty();
    }

    public static class TextFilter {
        public final String field;
        public final String value;

        public TextFilter(String field, String value) {
            this.field = field;
            this.value = value;
        }
    }
}
