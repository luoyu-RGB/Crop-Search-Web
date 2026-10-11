package com.cropknowledge.service;

import com.cropknowledge.model.Crop;
import com.cropknowledge.model.DeepSeekAnswer;
import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.function.BiFunction;
import java.util.function.Function;

/** Prefers approved crop data and falls back to a general DeepSeek answer. */
public final class DeepSeekAnswerService {
    private final BiFunction<String, String, String> complete;
    private final Function<String, DeepSeekAnswer> webAnswer;
    private final DeepSeekPromptService prompts = new DeepSeekPromptService();

    public DeepSeekAnswerService(DeepSeekService deepSeek, WebSearchService webSearch) {
        this(deepSeek::complete, question -> {
            try { return deepSeek.answerWithWebSearch(question, webSearch); }
            catch (IOException ex) { throw new WebSearchException(ex); }
        });
    }

    DeepSeekAnswerService(BiFunction<String, String, String> complete,
                          Function<String, DeepSeekAnswer> webAnswer) {
        this.complete = Objects.requireNonNull(complete);
        this.webAnswer = Objects.requireNonNull(webAnswer);
    }

    public DeepSeekAnswer answer(List<Crop> crops, String question) {
        if (question == null || question.trim().isEmpty()) throw new IllegalArgumentException("请输入问题");
        if (crops == null || crops.isEmpty()) {
            return webAnswer.apply(question.trim());
        }
        StringBuilder contexts = new StringBuilder();
        StringBuilder sources = new StringBuilder("\n数据库资料来源：");
        for (Crop crop : crops) {
            if (contexts.length() > 0) contexts.append("\n");
            contexts.append(context(crop));
            sources.append("\n").append(crop.chineseName).append("：")
                .append(crop.sourcePage > 0 ? "课程设计资料 PDF 第" + crop.sourcePage + "页" : "来源页未记录");
        }
        String response = complete.apply(prompts.buildSystemPrompt(), prompts.buildUserPrompt(question, contexts.toString()));
        Crop single = crops.size() == 1 ? crops.get(0) : null;
        return new DeepSeekAnswer(response + sources, single == null ? 0 : single.id,
            single == null ? 0 : single.sourcePage, true);
    }

    private static String context(Crop crop) {
        StringBuilder text = new StringBuilder();
        append(text, "作物名称", crop.chineseName); append(text, "英文名", crop.englishName); append(text, "拉丁名", crop.latinName);
        append(text, "科", crop.family); append(text, "属", crop.genus); append(text, "主要特征", crop.features);
        append(text, "分布", crop.distribution); append(text, "栽培", crop.cultivation); append(text, "用途", crop.uses);
        if (crop.maxOilContent != null) append(text, "最高含油率", crop.maxOilContent.toPlainString() + "%");
        if (crop.maxIodineValue != null) append(text, "最高碘值", crop.maxIodineValue.toPlainString());
        return text.toString();
    }
    private static void append(StringBuilder text, String label, String value) { if (value != null && !value.trim().isEmpty()) text.append(label).append("：").append(value.trim()).append("\n"); }

    public static final class WebSearchException extends RuntimeException {
        public WebSearchException() { super("没有找到可用的网页搜索结果"); }
        public WebSearchException(IOException cause) { super("网页搜索失败", cause); }
    }
}
