package org.example.common.api.util;

import java.util.UUID;

/**
 * Utility class for generating and managing keys.
 * Provides methods to create unique keys for various purposes.
 */
public class KeyUtil {

    /**
     * Generates a random unique key as a string by using a UUID.
     *
     * @return a randomly generated unique key in the form of a string
     */
    public static String generateRandomKey() {
        return UUID.randomUUID().toString();
    }
}
