package com.yunussemree.fungify.repository;

import com.yunussemree.fungify.entity.Fungy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FungyRepository {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public FungyRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Fungy> findAll() {
        return jdbcTemplate.query(
                "SELECT * FROM fungies",
                (rs, rowNum) -> new Fungy(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getBoolean("venomous"),
                        rs.getString("fungyImageUrl"),
                        rs.getString("fungyDescription")
                )
        );
    }
}
