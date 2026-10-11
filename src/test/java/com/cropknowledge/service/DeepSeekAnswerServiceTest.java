package com.cropknowledge.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.cropknowledge.model.Crop;
import com.cropknowledge.model.DeepSeekAnswer;
import com.cropknowledge.model.WebSource;
import java.util.Arrays;
import java.util.Collections;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.jupiter.api.Test;

class DeepSeekAnswerServiceTest {
    @Test
    void missingCropUsesWebResultsWithoutPdfSource() {
        AtomicReference<String> searched = new AtomicReference<>();
        DeepSeekAnswerService service = new DeepSeekAnswerService((systemPrompt, userPrompt) -> {
            throw new AssertionError("database prompt must not be used");
        }, question -> {
            searched.set(question);
            return new DeepSeekAnswer("联网回答", 0, 0, false,
                Collections.singletonList(new WebSource("油茶资料", "https://example.org/camellia", "可榨油")));
        });

        DeepSeekAnswer answer = service.answer(Collections.<Crop>emptyList(), "油茶有什么用途？");

        assertEquals("联网回答", answer.getText());
        assertEquals(0, answer.getCropId());
        assertEquals(0, answer.getSourcePage());
        assertEquals("油茶有什么用途？", searched.get());
        assertEquals(1, answer.getWebSources().size());
        assertTrue(answer.getHistoryText().contains("https://example.org/camellia"));
    }

    @Test
    void noWebResultsDoesNotCallTheModel() {
        DeepSeekAnswerService service = new DeepSeekAnswerService((system, user) -> {
            throw new AssertionError("model should not be called");
        }, question -> { throw new DeepSeekAnswerService.WebSearchException(new WebSearchService.NoResultsException()); });
        assertThrows(DeepSeekAnswerService.WebSearchException.class,
            () -> service.answer(Collections.<Crop>emptyList(), "油茶有什么用途？"));
    }

    @Test
    void approvedCropUsesItsDataAndPdfPage() {
        Crop crop = new Crop();
        crop.id = 7;
        crop.chineseName = "银杏";
        crop.uses = "可供观赏";
        crop.sourcePage = 12;
        AtomicReference<String> system = new AtomicReference<>();
        AtomicReference<String> user = new AtomicReference<>();
        DeepSeekAnswerService service = new DeepSeekAnswerService((systemPrompt, userPrompt) -> {
            system.set(systemPrompt);
            user.set(userPrompt);
            return "资料回答";
        }, question -> { throw new AssertionError("database match must skip web search"); });

        DeepSeekAnswer answer = service.answer(Collections.singletonList(crop), "银杏有什么用途？");

        assertEquals(7, answer.getCropId());
        assertEquals(12, answer.getSourcePage());
        assertTrue(answer.getText().contains("资料回答"));
        assertTrue(answer.getText().contains("数据库资料来源：\n银杏：课程设计资料 PDF 第12页"));
        assertTrue(user.get().contains("用途：可供观赏"));
        assertTrue(system.get().contains("优先依据"));
        assertTrue(answer.isDatabaseUsed());
    }

    @Test
    void comparisonUsesBothDatabaseRecordsAndTheirOwnPages() {
        Crop first = new Crop();
        first.id = 7; first.chineseName = "银杏"; first.sourcePage = 12;
        Crop second = new Crop();
        second.id = 8; second.chineseName = "苏铁"; second.sourcePage = 1;
        AtomicReference<String> user = new AtomicReference<>();
        DeepSeekAnswerService service = new DeepSeekAnswerService((system, prompt) -> {
            user.set(prompt);
            return "比较回答";
        }, question -> { throw new AssertionError("database match must skip web search"); });

        DeepSeekAnswer answer = service.answer(Arrays.asList(first, second), "银杏和苏铁有什么区别？");

        assertTrue(answer.isDatabaseUsed());
        assertEquals(0, answer.getCropId());
        assertTrue(answer.getText().contains("银杏：课程设计资料 PDF 第12页"));
        assertTrue(answer.getText().contains("苏铁：课程设计资料 PDF 第1页"));
        assertTrue(user.get().contains("作物名称：银杏"));
        assertTrue(user.get().contains("作物名称：苏铁"));
    }
}
