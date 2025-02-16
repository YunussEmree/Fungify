package com.yunussemree.fungify.repository;

import com.yunussemree.fungify.entity.Fungy;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DbHelper {

    private static final String URL = "jdbc:sqlite:../Database/fungy.db";

    public static Connection connect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return conn;
    }

    public static Fungy findByMushroomName(String mushroomName) {
        Fungy fungy = new Fungy();

        try {
            Connection conn = connect();
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
            closeConnection(connect());

        }
        return null;
    }

    public static void closeConnection(Connection conn) {
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}