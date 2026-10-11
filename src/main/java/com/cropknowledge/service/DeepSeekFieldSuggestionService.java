package com.cropknowledge.service;

import com.cropknowledge.model.DeepSeekFieldSuggestion;

/** Uses DeepSeek to propose OCR fields; the raw response stays a review-only proposal. */
public final class DeepSeekFieldSuggestionService {
    private final DeepSeekService deepSeek;
    public DeepSeekFieldSuggestionService(DeepSeekService deepSeek) { this.deepSeek=deepSeek; }
    public DeepSeekFieldSuggestion suggest(String ocrText, int sourcePage) {
        if (ocrText == null || ocrText.trim().isEmpty()) throw new IllegalArgumentException("OCR 文本不能为空");
        if (sourcePage < 1) throw new IllegalArgumentException("来源页码无效");
        String system = "你是作物资料录入助手。请从 OCR 文本提取中文名、英文名、拉丁名、科、属、特征、分布、栽培、用途和别名。"
            + "只输出 JSON 建议，不要编造缺失字段。结果必须由管理员人工审核，不能视为已发布资料。";
        String response = deepSeek.complete(system, "来源 PDF 第" + sourcePage + "页。OCR 文本：\n" + ocrText.trim());
        return new DeepSeekFieldSuggestion(response, sourcePage);
    }
}
