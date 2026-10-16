package com.cropknowledge.web;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import com.cropknowledge.model.CropSearch;
import java.math.BigDecimal;
import org.junit.jupiter.api.Test;

class SearchHistoryFormatterTest {
    @Test
    void summarizesOnlyReadableSearchCriteria() {
        CropSearch search = new CropSearch();
        assertEquals("", SearchHistoryFormatter.summarize(search));
        search.name = "油茶";
        search.minOil = new BigDecimal("20.00");
        search.maxOil = new BigDecimal("35");
        assertEquals("名称：油茶 · 含油率：20–35%", SearchHistoryFormatter.summarize(search));
    }

    @Test
    void decodesLegacyUrlQueryAndDropsEmptyParameters() {
        String display = SearchHistoryFormatter.display("name=%E6%B2%B9%E8%8C%B6&minOil=20&page=2&match=all");
        assertEquals("名称：油茶 · 含油率 ≥：20", display);
        assertTrue(SearchHistoryFormatter.display("page=2&match=all").isEmpty());
    }
}
