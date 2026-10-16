package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import jakarta.servlet.http.HttpServletRequest;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import java.util.Collections;
import org.junit.jupiter.api.Test;

class CropSearchServiceTest {
    private final CropSearchService service = new CropSearchService();

    @Test
    void parsesNameAndSelectedConditions() {
        Map<String, String> values = new HashMap<>();
        values.put("name", "  苏铁  ");
        values.put("filterField", "family,uses,");
        values.put("filterValue", "苏铁科,食用,");
        assertEquals("苏铁", service.parse(request(values)).name);
        assertEquals(2, service.parse(request(values)).textFilters.size());
        assertEquals("family", service.parse(request(values)).textFilters.get(0).field);
    }

    @Test
    void rejectsUnknownSearchField() {
        Map<String, String> values = new HashMap<>();
        values.put("filterField", "review_status");
        values.put("filterValue", "APPROVED");
        assertThrows(IllegalArgumentException.class, () -> service.parse(request(values)));
    }

    @Test
    void ignoresEmptyConditionAndRequiresFieldForValue() {
        Map<String, String> values = new HashMap<>();
        values.put("filterField", "family,");
        values.put("filterValue", ",");
        assertEquals(0, service.parse(request(values)).textFilters.size());
        values.put("filterValue", "松科,");
        assertEquals(1, service.parse(request(values)).textFilters.size());
        values.put("filterField", ",");
        assertThrows(IllegalArgumentException.class, () -> service.parse(request(values)));
    }

    @Test
    void acceptsOnlyValuesAvailableForTheSelectedField() {
        Map<String, String> values = new HashMap<>();
        values.put("filterField", "family");
        values.put("filterValue", "松科");
        Map<String, java.util.List<String>> options = Collections.singletonMap("family", Arrays.asList("松科", "苏铁科"));
        service.validateFilterOptions(service.parse(request(values)), options);
        values.put("filterValue", "无效值");
        assertThrows(IllegalArgumentException.class, () ->
            service.validateFilterOptions(service.parse(request(values)), options));
    }

    @Test
    void rejectsPathologicalPageOffsets() {
        Map<String, String> values = new HashMap<>();
        values.put("page", "1001");
        assertThrows(IllegalArgumentException.class, () -> service.parse(request(values)));
        values.put("page", "1000");
        assertEquals(1000, service.parse(request(values)).page);
    }

    private static HttpServletRequest request(Map<String, String> values) {
        return (HttpServletRequest) Proxy.newProxyInstance(
            HttpServletRequest.class.getClassLoader(), new Class<?>[]{HttpServletRequest.class},
            (proxy, method, args) -> {
                if ("getParameter".equals(method.getName())) return values.get(args[0]);
                if ("getParameterValues".equals(method.getName())) {
                    String value = values.get(args[0]);
                    return value == null ? null : value.split(",", -1);
                }
                return null;
            });
    }
}
