package com.cropknowledge.security;

import java.time.Duration;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.concurrent.ConcurrentHashMap;

/** Small process-local sliding-window limiter for expensive AI calls. */
public final class AiRateLimiter {
    private final int limit;
    private final long windowMillis;
    private final ConcurrentHashMap<String, Deque<Long>> windows = new ConcurrentHashMap<>();

    public AiRateLimiter(int limit, Duration window) {
        if (limit < 1 || window == null || window.isNegative() || window.isZero()) throw new IllegalArgumentException();
        this.limit = limit;
        this.windowMillis = window.toMillis();
    }

    public boolean tryAcquire(String key) {
        if (key == null || key.trim().isEmpty()) return false;
        long now = System.currentTimeMillis();
        Deque<Long> timestamps = windows.computeIfAbsent(key, ignored -> new ArrayDeque<>());
        synchronized (timestamps) {
            while (!timestamps.isEmpty() && timestamps.peekFirst() <= now - windowMillis) timestamps.removeFirst();
            if (timestamps.size() >= limit) return false;
            timestamps.addLast(now);
            if (windows.size() > 1000) removeExpired(now);
            return true;
        }
    }

    public int size() { return windows.size(); }

    private void removeExpired(long now) {
        for (java.util.Map.Entry<String, Deque<Long>> entry : windows.entrySet()) {
            Deque<Long> timestamps = entry.getValue();
            synchronized (timestamps) {
                while (!timestamps.isEmpty() && timestamps.peekFirst() <= now - windowMillis) timestamps.removeFirst();
                if (timestamps.isEmpty()) windows.remove(entry.getKey(), timestamps);
            }
        }
    }
}
