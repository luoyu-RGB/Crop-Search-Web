package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class DeepSeekPromptServiceTest {
    @Test
    void promptPrioritizesApprovedContextAndLabelsGeneralSupplement() {
        DeepSeekPromptService prompts = new DeepSeekPromptService();
        String system = prompts.buildSystemPrompt();
        String user = prompts.buildUserPrompt("油茶的用途是什么？", "用途：制油\n来源页：8");
        assertTrue(system.contains("优先依据"));
        assertTrue(system.contains("通用知识补充"));
        assertTrue(system.contains("不得把通用知识归于 PDF"));
        assertTrue(user.contains("用途：制油"));
        assertTrue(user.contains("油茶的用途是什么"));
    }
}
