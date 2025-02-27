package com.yunussemree.fungify.util.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.regex.Pattern;

/**
 * Utility class for SQL security operations
 */
@Component
public class SqlSecurityUtil {

    // Updated regex pattern to detect more SQL injection attempts
    private static final Pattern SQL_INJECTION_PATTERN =
            Pattern.compile("['\"\\-;=*+<>()&|!]|(/\\*.*?\\*/)|(--)|(\\b(OR|AND)\\b\\s+\\w+\\s*=\\s*\\w+)");

    // List of common SQL keywords that shouldn't appear in normal input
    private static final List<String> SQL_KEYWORDS = List.of(
            "select", "insert", "update", "delete", "drop", "alter", "truncate",
            "union", "exec", "where", "from", "having", "group by", "order by",
            "create", "table", "into", "procedure", "limit", "desc", "asc"
    );

    private final SecurityLogger securityLogger;

    @Autowired
    public SqlSecurityUtil(SecurityLogger securityLogger) {
        this.securityLogger = securityLogger;
    }

    /**
     * Validates input for potential SQL injection attempts
     *
     * @param input The string to validate
     * @return true if the input is safe, false otherwise
     */
    public boolean validateInput(String input) {
        if (input == null || input.trim().isEmpty()) {
            return false;
        }

        // Check for common SQL injection patterns
        if (SQL_INJECTION_PATTERN.matcher(input).find()) {
            securityLogger.logSecurityBreach("SQL_INJECTION", "Detected injection pattern in input: " + input);
            return false;
        }

        // Check for SQL keywords that shouldn't be in normal input
        String lowerInput = input.toLowerCase();
        for (String keyword : SQL_KEYWORDS) {
            if (lowerInput.contains(keyword)) {
                securityLogger.logSecurityBreach("SQL_INJECTION", "Detected SQL keyword in input: " + keyword + " in: " + input);
                return false;
            }
        }

        // Check for multiple spaces (which might be used to bypass filters)
        if (input.contains("  ")) {
            securityLogger.logSecurityBreach("SQL_INJECTION", "Detected multiple spaces in input: " + input);
            return false;
        }

        // Check for hex encoding attempts
        if (input.contains("0x") && input.matches(".*0x[0-9a-fA-F]{2,}.*")) {
            securityLogger.logSecurityBreach("SQL_INJECTION", "Detected hex encoding in input: " + input);
            return false;
        }

        return true;
    }

    /**
     * Sanitizes input to be safely used in SQL queries
     * Note: This is a basic sanitization and not a replacement for prepared statements
     *
     * @param input The string to sanitize
     * @return The sanitized string
     */
    public String sanitizeInput(String input) {
        if (input == null) {
            return "";
        }

        String original = input;

        // Remove potentially harmful characters
        String sanitized = input.replaceAll("[\"';\\\\]", "");

        // Remove comments
        sanitized = sanitized.replaceAll("/\\*.*?\\*/", "");
        sanitized = sanitized.replaceAll("--.*", "");

        // Log if sanitization changed the input (potential attack attempt)
        if (!original.equals(sanitized)) {
            securityLogger.logWarning("Input required sanitization: " + original + " -> " + sanitized);
        }

        return sanitized;
    }

    /**
     * Encodes a string for output to prevent XSS attacks
     *
     * @param input The string to encode
     * @return The encoded string
     */
    public String encodeForOutput(String input) {
        if (input == null) {
            return "";
        }

        // URL olup olmadığını kontrol et veya metin içi özellikler için bir ön işlem yap
        boolean isUrl = input.startsWith("http://") || input.startsWith("https://");
        boolean isDescription = input.length() > 30 && input.contains(" "); // Olası bir açıklama alanı

        String original = input;
        String encoded;

        if (isUrl) {
            // URL ise sadece HTML tag açma/kapama karakterlerini kodla
            encoded = input
                    .replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;");
        } else if (isDescription) {
            // Uzun açıklama metni ise, yalnızca kritik XSS karakterlerini kodla
            encoded = input
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
        } else {
            // Normal metin ise tüm özel karakterleri kodla
            encoded = input
                    .replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;")
                    .replace("\\", "&#x5C;");
        }

        // Log if encoding changed the input (potential XSS attempt)
        if (!original.equals(encoded)) {
            securityLogger.logWarning("Output required encoding: " + original + " -> " + encoded);
        }

        return encoded;
    }
} 