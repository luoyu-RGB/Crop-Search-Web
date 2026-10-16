package com.cropknowledge.security;

import static org.junit.jupiter.api.Assertions.*;
import java.time.Duration;
import org.junit.jupiter.api.Test;

class AiRateLimiterTest {
    @Test
    void rejectsAfterLimitAndRecoversAfterWindow() throws Exception {
        AiRateLimiter limiter = new AiRateLimiter(2, Duration.ofMillis(40));
        assertTrue(limiter.tryAcquire("user:1"));
        assertTrue(limiter.tryAcquire("user:1"));
        assertFalse(limiter.tryAcquire("user:1"));
        Thread.sleep(60);
        assertTrue(limiter.tryAcquire("user:1"));
    }

    @Test
    void isolatesKeys() {
        AiRateLimiter limiter = new AiRateLimiter(1, Duration.ofMinutes(1));
        assertTrue(limiter.tryAcquire("user:1"));
        assertTrue(limiter.tryAcquire("user:2"));
    }
}
