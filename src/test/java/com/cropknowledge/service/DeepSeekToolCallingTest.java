package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.cropknowledge.model.DeepSeekAnswer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.jupiter.api.Test;

class DeepSeekToolCallingTest {
    @Test
    void callsBrowserSearchAndSendsItsResultsBackToDeepSeek() throws Exception {
        ObjectMapper json = new ObjectMapper();
        AtomicInteger requests = new AtomicInteger();
        AtomicBoolean toolDefinitionSeen = new AtomicBoolean();
        AtomicBoolean toolResultSeen = new AtomicBoolean();
        HttpServer model = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        model.createContext("/chat/completions", exchange -> {
            JsonNode request = json.readTree(exchange.getRequestBody());
            int number = requests.incrementAndGet();
            String message;
            String finishReason;
            if (number == 1) {
                toolDefinitionSeen.set("browser_search".equals(request.path("tools").path(0)
                    .path("function").path("name").asText())
                    && "browser_search".equals(request.path("tool_choice").path("function").path("name").asText()));
                message = "{\"role\":\"assistant\",\"content\":null,\"tool_calls\":[{\"id\":\"call_1\","
                    + "\"type\":\"function\",\"function\":{\"name\":\"browser_search\",\"arguments\":\"{}\"}}]}";
                finishReason = "tool_calls";
            } else {
                for (JsonNode entry : request.path("messages")) {
                    if ("tool".equals(entry.path("role").asText())
                            && "call_1".equals(entry.path("tool_call_id").asText())
                            && entry.path("content").asText().contains("https://example.org/tea")) {
                        toolResultSeen.set(true);
                    }
                }
                message = "{\"role\":\"assistant\",\"content\":\"油茶可榨油 [1]\"}";
                finishReason = "stop";
            }
            String response = "{\"id\":\"chatcmpl-test\",\"object\":\"chat.completion\","
                + "\"created\":1,\"model\":\"deepseek-chat\",\"choices\":[{\"index\":0,"
                + "\"message\":" + message + ",\"finish_reason\":\"" + finishReason + "\"}]}";
            byte[] body = response.getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(200, body.length);
            try (java.io.OutputStream output = exchange.getResponseBody()) { output.write(body); }
        });
        HttpServer search = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        search.createContext("/search", exchange -> {
            byte[] body = ("<rss><channel><item><title>油茶资料</title>"
                + "<link>https://example.org/tea</link><description>可榨油</description>"
                + "</item></channel></rss>").getBytes(StandardCharsets.UTF_8);
            exchange.sendResponseHeaders(200, body.length);
            try (java.io.OutputStream output = exchange.getResponseBody()) { output.write(body); }
        });
        model.start();
        search.start();
        try (DeepSeekService deepSeek = new DeepSeekService("test-key",
                "http://127.0.0.1:" + model.getAddress().getPort(), "deepseek-chat")) {
            DeepSeekAnswer answer = deepSeek.answerWithWebSearch("油茶有什么用途？",
                new WebSearchService(URI.create("http://127.0.0.1:" + search.getAddress().getPort() + "/search")));
            assertEquals("油茶可榨油 [1]", answer.getText());
            assertEquals(1, answer.getWebSources().size());
            assertEquals(2, requests.get());
            assertTrue(toolDefinitionSeen.get());
            assertTrue(toolResultSeen.get());
        } finally {
            model.stop(0);
            search.stop(0);
        }
    }
}
