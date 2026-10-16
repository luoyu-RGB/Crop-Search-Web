package com.cropknowledge.web;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class CropSearchServletTest {
    @Test
    void searchHistoryQueryIsBounded() {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < 4001; i++) builder.append('x');
        String longQuery = builder.toString();
        assertTrue(CropSearchServlet.normalizeQuery(longQuery).length() == 4000);
        assertTrue(CropSearchServlet.normalizeQuery(null).isEmpty());
    }
}
