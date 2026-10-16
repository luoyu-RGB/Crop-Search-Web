package com.cropknowledge.dao;

import static org.junit.jupiter.api.Assertions.assertEquals;
import com.cropknowledge.model.SearchRecord;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.Test;

class SearchRecordDaoTest {
    @Test
    void recentSearchesKeepNewestEntryForEachQuery() {
        LocalDateTime now = LocalDateTime.now();
        List<SearchRecord> records = SearchRecordDao.deduplicateRecent(Arrays.asList(
            new SearchRecord(3, "名称：红皮云杉", 1, now),
            new SearchRecord(2, "名称：红皮云杉", 1, now.minusMinutes(1)),
            new SearchRecord(1, "名称：苏铁", 1, now.minusMinutes(2))), 10);

        assertEquals(2, records.size());
        assertEquals(3, records.get(0).id);
        assertEquals(1, records.get(1).id);
    }
}
