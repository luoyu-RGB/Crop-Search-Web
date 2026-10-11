package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.Test;

class DeepSeekServiceTest {
    @Test
    void missingKeyShowsOnlyTheFixedEnvironmentVariableName() {
        IllegalStateException error = assertThrows(IllegalStateException.class,
            () -> DeepSeekService.requiredApiKey(null));
        assertEquals("请在服务器环境变量中配置 DEEPSEEK_API_KEY", error.getMessage());
    }

    @Test
    void configuredKeyIsReadAsTheValue() {
        assertEquals("test-key", DeepSeekService.requiredApiKey(" test-key "));
    }
}
