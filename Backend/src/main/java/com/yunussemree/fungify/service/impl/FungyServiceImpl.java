package com.yunussemree.fungify.service.impl;

import com.yunussemree.fungify.entity.Fungy;
import com.yunussemree.fungify.service.IFungyService;
import org.springframework.stereotype.Service;

import java.sql.*;


@Service
public class FungyServiceImpl implements IFungyService {

    @Override
    public Fungy findByMushroomName(String mushroomName) {

        final String URL = "jdbc:sqlite:../Database/fungy.db";
        Fungy fungy = new Fungy();
        Connection conn = null;

        try {
            conn = DriverManager.getConnection(URL);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM fungies WHERE name = '" + mushroomName + "'");

            fungy.setId(rs.getLong("id"));
            fungy.setName(rs.getString("name"));
            fungy.setVenomous(rs.getBoolean("venomous"));
            fungy.setFungyImageUrl(rs.getString("fungyImageUrl"));
            fungy.setFungyDescription(rs.getString("fungyDescription"));

            return fungy;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                System.out.println(e.getMessage());
            }

        }
        return null;
    }
}
