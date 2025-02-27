package com.yunussemree.fungify.exception;

import com.yunussemree.fungify.util.security.SecurityLogger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;

/**
 * Handler for configuring the DatabaseException with the required dependencies.
 * This class bridges the gap between Spring managed beans and the static
 * context of DatabaseException.
 */
@Component
public class DatabaseExceptionHandler {

    private final SecurityLogger securityLogger;
    
    @Autowired
    public DatabaseExceptionHandler(SecurityLogger securityLogger) {
        this.securityLogger = securityLogger;
    }
    
    /**
     * Initializes the DatabaseException with the SecurityLogger
     * after this bean is constructed by Spring
     */
    @PostConstruct
    public void init() {
        DatabaseException.setSecurityLogger(securityLogger);
    }
} 