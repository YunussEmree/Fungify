package com.yunussemree.fungify.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

@Configuration
public class SQLiteConfig {

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("org.sqlite.JDBC");
        dataSource.setUrl("jdbc:sqlite:../Database/fungify.db");

        applyPragmaSettings(dataSource);

        return dataSource;
    }


    private void applyPragmaSettings(DataSource dataSource) {
        try (Connection connection = dataSource.getConnection();
             Statement statement = connection.createStatement()) {
            statement.execute("PRAGMA foreign_keys = ON;");
            statement.execute("PRAGMA journal_mode = WAL;");
            statement.execute("PRAGMA synchronous = NORMAL;");
            statement.execute("PRAGMA temp_store = MEMORY;");
        } catch (SQLException e) {
            throw new RuntimeException("Failed to apply PRAGMA settings for SQLite", e);
        }
    }
}
