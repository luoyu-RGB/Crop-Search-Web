package com.cropknowledge.security;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class PasswordHasherTest {
    @Test
    void verifiesOnlyCorrectPassword() {
        String encoded = PasswordHasher.hash("correct-password");
        assertTrue(PasswordHasher.verify("correct-password", encoded));
        assertFalse(PasswordHasher.verify("wrong-password", encoded));
        assertFalse(PasswordHasher.verify("correct-password", "bad-hash"));
    }
}
