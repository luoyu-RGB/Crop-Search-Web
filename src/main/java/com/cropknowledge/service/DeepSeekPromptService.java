package com.cropknowledge.service;

/** Builds a grounded prompt so DeepSeek can only answer from approved crop context. */
public final class DeepSeekPromptService {
    public String buildSystemPrompt() {
        return "你是作物知识库助手。只能依据用户提供的已审核资料回答，不得补造资料。"
            + "如果资料没有答案，必须明确说无法确认。回答简洁，并保留来源页信息。";
    }

    public String buildUserPrompt(String question, String cropContext) {
        if (question == null || question.trim().isEmpty()) throw new IllegalArgumentException("请输入问题");
        if (cropContext == null || cropContext.trim().isEmpty()) return "问题：" + question.trim() + "\n已审核资料：无。请明确说明无法确认。";
        return "问题：" + question.trim() + "\n已审核资料：\n" + cropContext.trim();
    }
}
