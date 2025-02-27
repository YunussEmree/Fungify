package com.yunussemree.fungify.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.sqlite.SQLiteConfig;
import org.sqlite.SQLiteDataSource;

import javax.sql.DataSource;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.SQLException;

@Configuration
public class DatabaseConfig {

    private static final String DB_PATH = "../Database/fungy.db";
    private static final int CONNECTION_TIMEOUT = 30000; // 30 seconds
    private static final int MAX_POOL_SIZE = 2; // Reduced even more for SQLite
    private static final int MIN_IDLE = 1; // Single idle connection
    private static final long MAX_LIFETIME = 1800000; // 30 minutes
    private static final long LEAK_DETECTION_THRESHOLD = 60000; // 1 minute
    private static final int BUSY_TIMEOUT = 30000; // 30 seconds

    @Bean
    public DataSource sqliteDataSource() {
        SQLiteConfig sqliteConfig = new SQLiteConfig();
        configureSqlite(sqliteConfig);

        SQLiteDataSource sqliteDataSource = new SQLiteDataSource(sqliteConfig);
        Path dbPath = Paths.get(DB_PATH).toAbsolutePath().normalize();
        sqliteDataSource.setUrl("jdbc:sqlite:" + dbPath + "?busy_timeout=" + BUSY_TIMEOUT);

        HikariConfig hikariConfig = new HikariConfig();
        hikariConfig.setDataSource(sqliteDataSource);
        hikariConfig.setPoolName("SQLitePool");
        hikariConfig.setMaximumPoolSize(MAX_POOL_SIZE);
        hikariConfig.setMinimumIdle(MIN_IDLE);
        hikariConfig.setConnectionTimeout(CONNECTION_TIMEOUT);
        hikariConfig.setMaxLifetime(MAX_LIFETIME);
        hikariConfig.setAutoCommit(false);
        hikariConfig.setLeakDetectionThreshold(LEAK_DETECTION_THRESHOLD);
        hikariConfig.setConnectionTestQuery("SELECT 1");

        hikariConfig.setAllowPoolSuspension(true);
        hikariConfig.setInitializationFailTimeout(5000);
        hikariConfig.setKeepaliveTime(120000);

        hikariConfig.setConnectionInitSql(
                "PRAGMA foreign_keys = ON; " +
                        "PRAGMA secure_delete = ON; " +
                        "PRAGMA cell_size_check = ON; " +
                        "PRAGMA auto_vacuum = FULL; " +
                        "PRAGMA busy_timeout = " + BUSY_TIMEOUT + ";"
        );

        HikariDataSource dataSource = new HikariDataSource(hikariConfig);
        testConnection(dataSource);

        return dataSource;
    }

    private void configureSqlite(SQLiteConfig config) {
        config.setJournalMode(SQLiteConfig.JournalMode.WAL);
        config.enforceForeignKeys(true);
        config.setTransactionMode(SQLiteConfig.TransactionMode.IMMEDIATE);
        config.setBusyTimeout(BUSY_TIMEOUT);
        config.setSynchronous(SQLiteConfig.SynchronousMode.NORMAL);
        config.setLockingMode(SQLiteConfig.LockingMode.NORMAL);
    }

    private void testConnection(DataSource dataSource) {
        try (Connection conn = dataSource.getConnection()) {
            if (conn == null) {
                throw new SQLException("Could not establish database connection");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize SQLite datasource", e);
        }
    }
} 