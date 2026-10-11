package com.cropknowledge.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Crop {
    public long id;
    public String chineseName;
    public String englishName;
    public String latinName;
    public String family;
    public String genus;
    public String features;
    public String distribution;
    public String cultivation;
    public String uses;
    public int sourcePage;
    public String reviewStatus;
    public String coverPath;
    public String aliasSummary;
    public BigDecimal maxOilContent;
    public BigDecimal maxIodineValue;
    public BigDecimal maxAcidValue;
    public BigDecimal maxSaponificationValue;
    public final List<String> aliases = new ArrayList<>();
    public final List<Image> images = new ArrayList<>();
    public final List<Sample> samples = new ArrayList<>();

    public static class Image {
        public String path;
        public String title;
    }

    public static class Sample {
        public String origin;
        public String testPart;
        public BigDecimal oilContent;
        public BigDecimal iodineValue;
        public BigDecimal acidValue;
        public BigDecimal saponificationValue;
        public final List<Component> components = new ArrayList<>();
    }

    public static class Component {
        public String name;
        public BigDecimal value;
    }
}
