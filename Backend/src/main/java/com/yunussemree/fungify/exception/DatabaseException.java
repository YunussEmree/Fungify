package com.yunussemree.fungify.exception;

import com.yunussemree.fungify.util.security.SecurityLogger;

/**
 * Exception thrown for database-related errors
 */
public class DatabaseException extends RuntimeException {
    
    private static SecurityLogger securityLogger;
    
    /**
     * Sets the security logger for database exceptions
     * This method is used by {@link DatabaseExceptionHandler} to inject the logger
     */
    public static void setSecurityLogger(SecurityLogger logger) {
        DatabaseException.securityLogger = logger;
    }

    public DatabaseException(String message) {
        super(message);
    }

    public DatabaseException(String message, Throwable cause) {
        super(message, cause);
    }
    
    /**
     * Creates an exception without exposing sensitive database information
     * 
     * @param internalMessage The detailed internal message (for logging)
     * @param userMessage The sanitized message for user display
     * @param cause The original exception
     * @return A new DatabaseException
     */
    public static DatabaseException createSecure(String internalMessage, String userMessage, Throwable cause) {
        // Log the detailed internal message and stack trace for developers
        if (securityLogger != null) {
            securityLogger.logError("Database error: " + internalMessage, cause);
        } else {
            // Fallback if logger is not initialized (during tests or early startup)
            System.err.println("Database error: " + internalMessage);
            cause.printStackTrace();
        }
        
        // Return an exception with a sanitized message for end users
        return new DatabaseException(userMessage, cause);
    }
} 