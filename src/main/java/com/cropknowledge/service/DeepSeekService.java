package com.cropknowledge.service;

import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.models.chat.completions.ChatCompletion;
import com.openai.models.chat.completions.ChatCompletionCreateParams;

/** DeepSeek adapter through its OpenAI-compatible Chat Completions endpoint. */
public final class DeepSeekService implements AutoCloseable {
    private final OpenAIClient client;
    private final String model;

    public DeepSeekService() {
        String apiKey = requiredApiKey(System.getenv("DEEPSEEK_API_KEY"));
        String baseUrl = valueOrDefault("DEEPSEEK_BASE_URL", "https://api.deepseek.com");
        this.model = valueOrDefault("DEEPSEEK_MODEL", "deepseek-chat");
        this.client = OpenAIOkHttpClient.builder().apiKey(apiKey).baseUrl(baseUrl).build();
    }

    public String complete(String systemPrompt, String userPrompt) {
        if (userPrompt == null || userPrompt.trim().isEmpty()) throw new IllegalArgumentException("用户问题不能为空");
        ChatCompletionCreateParams params = ChatCompletionCreateParams.builder()
            .model(model)
            .addSystemMessage(systemPrompt == null ? "" : systemPrompt)
            .addUserMessage(userPrompt.trim())
            .build();
        ChatCompletion completion = client.chat().completions().create(params);
        if (completion.choices().isEmpty() || !completion.choices().get(0).message().content().isPresent()) {
            throw new IllegalStateException("DeepSeek 未返回文本回答");
        }
        return completion.choices().get(0).message().content().get().trim();
    }

    public String getModel() { return model; }

    @Override public void close() { client.close(); }

    static String requiredApiKey(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new MissingApiKeyException();
        }
        return value.trim();
    }

    public static final class MissingApiKeyException extends IllegalStateException {
        public MissingApiKeyException() {
            super("请在服务器环境变量中配置 DEEPSEEK_API_KEY");
        }
    }
    private static String valueOrDefault(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
