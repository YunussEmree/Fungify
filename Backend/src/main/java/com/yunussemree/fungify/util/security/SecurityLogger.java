package com.yunussemree.fungify.util.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Utility class for logging security events
 */
@Component
public class SecurityLogger {

    private static final Logger logger = LoggerFactory.getLogger(SecurityLogger.class);
    private static final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    /**
     * Logs a security event with severity INFO
     * 
     * @param message The message to log
     */
    public void logInfo(String message) {
        logger.info(formatMessage(message));
    }
    
    /**
     * Logs a security event with severity WARNING
     * 
     * @param message The message to log
     */
    public void logWarning(String message) {
        logger.warn(formatMessage(message));
    }
    
    /**
     * Logs a security event with severity ERROR
     * 
     * @param message The message to log
     * @param exception The exception that caused the event
     */
    public void logError(String message, Throwable exception) {
        logger.error(formatMessage(message), exception);
    }
    
    /**
     * Logs a potential security breach attempt
     * 
     * @param attemptType The type of breach attempt
     * @param details Details about the attempt
     */
    public void logSecurityBreach(String attemptType, String details) {
        String message = String.format("[SECURITY BREACH ATTEMPT] Type: %s, Details: %s", 
                attemptType, details);
        logger.error(formatMessage(message));
        
        // In a production environment, you might want to trigger additional alerts
        // such as notifications to security teams
    }
    
    private String formatMessage(String message) {
        return String.format("[%s] %s", 
                LocalDateTime.now().format(dateFormatter), 
                message);
    }
} 