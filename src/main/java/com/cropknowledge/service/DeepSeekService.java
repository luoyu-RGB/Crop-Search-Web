package com.cropknowledge.service;

import com.cropknowledge.model.DeepSeekAnswer;
import com.cropknowledge.model.WebSource;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.models.FunctionDefinition;
import com.openai.models.chat.completions.ChatCompletion;
import com.openai.models.chat.completions.ChatCompletionCreateParams;
import com.openai.models.chat.completions.ChatCompletionMessage;
import com.openai.models.chat.completions.ChatCompletionMessageToolCall;
import com.openai.models.chat.completions.ChatCompletionNamedToolChoice;
import com.openai.models.chat.completions.ChatCompletionToolMessageParam;
import java.io.IOException;
import java.time.Duration;
import java.util.List;

/** DeepSeek adapter through its OpenAI-compatible Chat Completions endpoint. */
public final class DeepSeekService implements AutoCloseable {
    private final OpenAIClient client;
    private final String model;

    public DeepSeekService() {
        this(System.getenv("DEEPSEEK_API_KEY"), valueOrDefault("DEEPSEEK_BASE_URL", "https://api.deepseek.com"),
            valueOrDefault("DEEPSEEK_MODEL", "deepseek-chat"));
    }

    DeepSeekService(String apiKey, String baseUrl, String model) {
        this.model = model;
        this.client = OpenAIOkHttpClient.builder().apiKey(requiredApiKey(apiKey)).baseUrl(baseUrl)
            .timeout(Duration.ofSeconds(30)).maxRetries(1).build();
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

    /** Forces a search tool call, executes it locally, then returns the model's sourced answer. */
    public DeepSeekAnswer answerWithWebSearch(String question, WebSearchService search) throws IOException {
        FunctionDefinition browserSearch = FunctionDefinition.builder()
            .name("browser_search")
            .description("搜索用户问题相关的网页并返回标题、链接和摘要。无需参数。")
            .build();
        ChatCompletionNamedToolChoice choice = ChatCompletionNamedToolChoice.builder()
            .function(ChatCompletionNamedToolChoice.Function.builder().name("browser_search").build())
            .build();
        String systemPrompt = new DeepSeekPromptService().buildWebSystemPrompt();
        ChatCompletion first = client.chat().completions().create(ChatCompletionCreateParams.builder()
            .model(model)
            .addSystemMessage(systemPrompt)
            .addUserMessage(question)
            .addFunctionTool(browserSearch)
            .toolChoice(choice)
            .build());
        if (first.choices().isEmpty()) throw new IllegalStateException("DeepSeek 未请求网页搜索工具");
        ChatCompletionMessage message = first.choices().get(0).message();
        List<ChatCompletionMessageToolCall> calls = message.toolCalls().orElse(null);
        if (calls == null || calls.isEmpty()) throw new IllegalStateException("DeepSeek 未请求网页搜索工具");
        for (ChatCompletionMessageToolCall call : calls) {
            if (!call.function().isPresent() || !"browser_search".equals(call.function().get().function().name())) {
                throw new IllegalStateException("DeepSeek 请求了未知搜索工具");
            }
        }

        List<WebSource> sources = search.search(question);
        StringBuilder toolResult = new StringBuilder("网页搜索摘要：\n");
        for (int i = 0; i < sources.size(); i++) {
            WebSource source = sources.get(i);
            toolResult.append('[').append(i + 1).append("] ").append(source.getTitle())
                .append("\n网址：").append(source.getUrl())
                .append("\n摘要：").append(source.getDescription()).append("\n");
        }
        ChatCompletionCreateParams.Builder finalRequest = ChatCompletionCreateParams.builder()
            .model(model)
            .addSystemMessage(systemPrompt)
            .addUserMessage(question)
            .addMessage(message);
        for (ChatCompletionMessageToolCall call : calls) {
            finalRequest.addMessage(ChatCompletionToolMessageParam.builder()
                .toolCallId(call.function().get().id())
                .content(toolResult.toString())
                .build());
        }
        ChatCompletion finalCompletion = client.chat().completions().create(finalRequest.build());
        if (finalCompletion.choices().isEmpty() || !finalCompletion.choices().get(0).message().content().isPresent()) {
            throw new IllegalStateException("DeepSeek 未返回联网回答");
        }
        return new DeepSeekAnswer(finalCompletion.choices().get(0).message().content().get().trim(),
            0, 0, false, sources);
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
