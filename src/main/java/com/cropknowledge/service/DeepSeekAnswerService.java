package com.cropknowledge.service;

import com.cropknowledge.model.Crop;
import com.cropknowledge.model.DeepSeekAnswer;

/** Grounds DeepSeek answers in one APPROVED crop record and attaches its PDF source. */
public final class DeepSeekAnswerService {
    private final DeepSeekService deepSeek;
    private final DeepSeekPromptService prompts = new DeepSeekPromptService();

    public DeepSeekAnswerService(DeepSeekService deepSeek) { this.deepSeek = deepSeek; }

    public DeepSeekAnswer answer(Crop crop, String question) {
        if (crop == null) return new DeepSeekAnswer("没有匹配的已审核作物资料。请先在“作物查询”中确认名称，再提问。", 0, 0);
        String response = deepSeek.complete(prompts.buildSystemPrompt(), prompts.buildUserPrompt(question, context(crop)));
        String withSource = response + (crop.sourcePage > 0 ? "\n来源：课程设计资料 PDF 第" + crop.sourcePage + "页。" : "\n来源页未记录。请人工核对原始资料。");
        return new DeepSeekAnswer(withSource, crop.id, crop.sourcePage);
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
}
