package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class DeepSeekPromptServiceTest {
    @Test
    void promptCarriesApprovedContextAndNoFabricationRule() {
        DeepSeekPromptService prompts = new DeepSeekPromptService();
        String system = prompts.buildSystemPrompt();
        String user = prompts.buildUserPrompt("油茶的用途是什么？", "用途：制油\n来源页：8");
        assertTrue(system.contains("只能依据"));
        assertTrue(user.contains("用途：制油"));
        assertTrue(user.contains("油茶的用途是什么"));
    }
}
