package com.cropknowledge.service;

import com.cropknowledge.model.WebSource;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.helpers.DefaultHandler;

/** Reads public Bing web search results for the assistant's browser_search tool. */
public final class WebSearchService {
    private static final int MAX_RESPONSE_BYTES = 256 * 1024;
    private static final String BROWSER_USER_AGENT =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120 Safari/537.36";
    private final URI endpoint;

    public WebSearchService() {
        this(URI.create("https://www.bing.com/search"));
    }

    WebSearchService(URI endpoint) {
        this.endpoint = endpoint;
    }

    public List<WebSource> search(String question) throws IOException {
        if (question == null || question.trim().isEmpty()) throw new IllegalArgumentException("搜索问题不能为空");
        URI uri = URI.create(endpoint + "?q=" + URLEncoder.encode(question.trim(), "UTF-8") + "&format=rss");
        HttpURLConnection connection = (HttpURLConnection) uri.toURL().openConnection();
        connection.setRequestProperty("User-Agent", BROWSER_USER_AGENT);
        connection.setRequestProperty("Accept", "application/rss+xml, application/xml");
        connection.setRequestProperty("Accept-Language", "zh-CN,zh;q=0.9");
        connection.setConnectTimeout(5000);
        connection.setReadTimeout(10000);
        connection.setInstanceFollowRedirects(true);
        try {
            int status = connection.getResponseCode();
            if (status != 200) throw new SearchHttpException(status);
            List<WebSource> sources;
            try (InputStream input = connection.getInputStream()) {
                sources = parseResults(readLimited(input));
            }
            if (sources.isEmpty()) throw new NoResultsException();
            return sources;
        } finally {
            connection.disconnect();
        }
    }

    static List<WebSource> parseResults(byte[] response) throws IOException {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
            factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
            factory.setExpandEntityReferences(false);
            javax.xml.parsers.DocumentBuilder builder = factory.newDocumentBuilder();
            builder.setErrorHandler(new DefaultHandler() {
                @Override public void fatalError(SAXParseException ex) throws SAXException { throw ex; }
            });
            Element root = builder.parse(new ByteArrayInputStream(response)).getDocumentElement();
            NodeList items = root.getElementsByTagName("item");
            List<WebSource> sources = new ArrayList<>();
            for (int i = 0; i < items.getLength() && sources.size() < 5; i++) {
                Element item = (Element) items.item(i);
                String url = childText(item, "link");
                URI uri;
                try { uri = URI.create(url); }
                catch (IllegalArgumentException ex) { continue; }
                if (!("https".equalsIgnoreCase(uri.getScheme()) || "http".equalsIgnoreCase(uri.getScheme()))
                        || uri.getHost() == null || url.length() > 2048) continue;
                sources.add(new WebSource(limit(childText(item, "title"), 160), url,
                    limit(childText(item, "description").replaceAll("<[^>]*>", " "), 500)));
            }
            return sources;
        } catch (ParserConfigurationException | SAXException ex) {
            throw new IOException("搜索结果格式无效", ex);
        }
    }

    private static String childText(Element item, String name) {
        NodeList nodes = item.getElementsByTagName(name);
        return nodes.getLength() == 0 ? "" : nodes.item(0).getTextContent();
    }

    private static byte[] readLimited(InputStream input) throws IOException {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int read;
        while ((read = input.read(buffer)) != -1) {
            if (output.size() + read > MAX_RESPONSE_BYTES) throw new IOException("搜索响应过大");
            output.write(buffer, 0, read);
        }
        return output.toByteArray();
    }

    private static String limit(String value, int max) {
        String text = value.replaceAll("\\s+", " ").trim();
        return text.length() <= max ? text : text.substring(0, max);
    }

    public static final class NoResultsException extends IOException {
        public NoResultsException() { super("没有找到可用的网页搜索结果"); }
    }

    public static final class SearchHttpException extends IOException {
        private final int statusCode;
        public SearchHttpException(int statusCode) {
            super("搜索服务 HTTP " + statusCode);
            this.statusCode = statusCode;
        }
        public int getStatusCode() { return statusCode; }
    }
}
