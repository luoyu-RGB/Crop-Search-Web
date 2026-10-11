package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.cropknowledge.model.WebSource;
import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.List;
import org.junit.jupiter.api.Test;

class WebSearchServiceTest {
    @Test
    void parsesRssResultsAndRejectsUnsafeLinks() throws Exception {
        String rss = "<?xml version=\"1.0\" encoding=\"utf-8\"?><rss><channel>"
            + "<item><title>油茶资料</title><link>https://example.org/camellia</link>"
            + "<description>可以榨油</description></item>"
            + "<item><title>不安全</title><link>javascript:alert(1)</link>"
            + "<description>忽略</description></item></channel></rss>";
        List<WebSource> results = WebSearchService.parseResults(rss.getBytes(StandardCharsets.UTF_8));
        assertEquals(1, results.size());
        assertEquals("油茶资料", results.get(0).getTitle());
        assertEquals("https://example.org/camellia", results.get(0).getUrl());
    }

    @Test
    void rejectsXmlEntityDefinitions() {
        String rss = "<!DOCTYPE rss [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]>"
            + "<rss><channel><item><title>&xxe;</title></item></channel></rss>";
        assertThrows(java.io.IOException.class,
            () -> WebSearchService.parseResults(rss.getBytes(StandardCharsets.UTF_8)));
    }

    @Test
    void searchesPublicRssWithBrowserHeaders() throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        server.createContext("/search", exchange -> {
            boolean valid = exchange.getRequestHeaders().getFirst("User-Agent").contains("Mozilla/5.0")
                && exchange.getRequestURI().getRawQuery().contains("q=%E6%B2%B9%E8%8C%B6")
                && exchange.getRequestURI().getRawQuery().contains("format=rss");
            byte[] body = (valid
                ? "<?xml version=\"1.0\"?><rss><channel><item><title>油茶</title>"
                    + "<link>https://example.org/tea</link><description>资料</description></item></channel></rss>"
                : "<rss><channel/></rss>").getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "application/rss+xml");
            exchange.sendResponseHeaders(valid ? 200 : 400, body.length);
            try (java.io.OutputStream output = exchange.getResponseBody()) { output.write(body); }
        });
        server.start();
        try {
            URI endpoint = URI.create("http://127.0.0.1:" + server.getAddress().getPort() + "/search");
            List<WebSource> results = new WebSearchService(endpoint).search("油茶");
            assertEquals(1, results.size());
            assertTrue(results.get(0).getUrl().startsWith("https://"));
        } finally {
            server.stop(0);
        }
    }

    @Test
    void reportsSearchStatusAndEmptyResults() throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        server.createContext("/limited", exchange -> { exchange.sendResponseHeaders(429, -1); exchange.close(); });
        server.createContext("/empty", exchange -> {
            byte[] body = "<rss><channel/></rss>".getBytes(StandardCharsets.UTF_8);
            exchange.sendResponseHeaders(200, body.length);
            try (java.io.OutputStream output = exchange.getResponseBody()) { output.write(body); }
        });
        server.start();
        try {
            String base = "http://127.0.0.1:" + server.getAddress().getPort();
            WebSearchService.SearchHttpException limited = assertThrows(WebSearchService.SearchHttpException.class,
                () -> new WebSearchService(URI.create(base + "/limited")).search("作物"));
            assertEquals(429, limited.getStatusCode());
            assertThrows(WebSearchService.NoResultsException.class,
                () -> new WebSearchService(URI.create(base + "/empty")).search("作物"));
        } finally {
            server.stop(0);
        }
    }
}
