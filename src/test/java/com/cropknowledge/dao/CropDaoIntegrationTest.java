package com.cropknowledge.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

import com.cropknowledge.config.Database;
import com.cropknowledge.model.Crop;
import com.cropknowledge.model.CropPage;
import com.cropknowledge.model.CropSearch;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

class CropDaoIntegrationTest {
    private final CropDao dao = new CropDao();

    @BeforeAll
    static void databaseAvailable() {
        assumeTrue(System.getenv("CROP_DB_URL") != null, "Set CROP_DB_* to run MySQL integration tests");
    }

    @AfterAll
    static void closePool() { Database.close(); }

    @Test
    void searchesApprovedCropsWithThreeConditionsAndPagination() throws Exception {
        CropSearch search = new CropSearch();
        search.family = "松科";
        search.name = "松";
        search.minOil = new BigDecimal("20");
        CropPage first = dao.search(search);
        assertTrue(first.total > 0);
        assertTrue(first.crops.size() <= 10);
        for (Crop crop : first.crops) {
            assertEquals("松科", crop.family);
            assertTrue(crop.chineseName.contains("松") || crop.latinName.toLowerCase().contains("松"));
            assertTrue(crop.maxOilContent.compareTo(search.minOil) >= 0);
        }
        CropSearch all = new CropSearch();
        CropPage allFirst = dao.search(all);
        assertTrue(allFirst.total >= 30);
        all.page = 2;
        CropPage allSecond = dao.search(all);
        assertEquals(2, allSecond.page);
        assertFalse(allSecond.crops.isEmpty());
        assertFalse(allFirst.crops.get(0).id == allSecond.crops.get(0).id);
    }

    @Test
    void detailIncludesImageAndSamples() throws Exception {
        CropSearch search = new CropSearch();
        search.name = "苏铁";
        CropPage page = dao.search(search);
        assertEquals(1, page.total);
        Crop crop = dao.findById(page.crops.get(0).id, false);
        assertNotNull(crop);
        assertFalse(crop.images.isEmpty());
        assertFalse(crop.samples.isEmpty());
        assertEquals(1, crop.sourcePage);
    }

    @Test
    void nameSearchStaysIndependentOfSelectedConditions() throws Exception {
        CropSearch byName = new CropSearch();
        byName.name = "苏铁";
        assertEquals(1, dao.search(byName).total);

        CropSearch combined = new CropSearch();
        combined.name = "苏铁";
        combined.textFilters.add(new CropSearch.TextFilter("family", "苏铁科"));
        assertEquals(1, dao.search(combined).total);
        combined.textFilters.add(new CropSearch.TextFilter("uses", "没有这个用途"));
        assertEquals(0, dao.search(combined).total);
        combined.matchAny = true;
        assertEquals(1, dao.search(combined).total);
        combined.name = "不存在的作物";
        assertEquals(0, dao.search(combined).total);
    }

    @Test
    void dropdownOptionsIncludePublishedTaxonomyAndLocations() throws Exception {
        Map<String, List<String>> options = dao.filterOptions(false);
        assertTrue(options.get("family").contains("苏铁科"));
        assertTrue(options.get("genus").contains("苏铁属"));
        assertTrue(options.get("distribution").contains("广西"));
    }

    @Test
    void numericAndComponentConditionsShareASample() throws Exception {
        CropSearch search = new CropSearch();
        search.family = "松科";
        search.minOil = new BigDecimal("20");
        search.component = "C18:1";
        search.minComponent = new BigDecimal("40");
        CropPage page = dao.search(search);
        assertTrue(page.total > 0);
        for (Crop crop : page.crops) {
            Crop detail = dao.findById(crop.id, false);
            assertTrue(detail.samples.stream().anyMatch(sample ->
                sample.oilContent != null && sample.oilContent.compareTo(search.minOil) >= 0
                    && sample.components.stream().anyMatch(component ->
                        "C18:1".equals(component.name) && component.value.compareTo(search.minComponent) >= 0)));
        }
    }
}
