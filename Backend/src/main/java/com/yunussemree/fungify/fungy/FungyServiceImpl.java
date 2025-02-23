package com.yunussemree.fungify.fungy;

import org.springframework.stereotype.Service;
import java.sql.*;

@Service
public class FungyServiceImpl implements IFungyService {

    private static final String URL = "jdbc:sqlite:../Database/fungy.db";
    private static final String FIND_BY_NAME_QUERY = "SELECT * FROM fungies WHERE name = ?";

    @Override
    public Fungy findByMushroomName(String mushroomName) {
        try (Connection conn = DriverManager.getConnection(URL);
             PreparedStatement pstmt = conn.prepareStatement(FIND_BY_NAME_QUERY)) {
            
            pstmt.setString(1, mushroomName);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFungy(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Database error: " + e.getMessage(), e);
        }
        return null;
    }

    private Fungy mapResultSetToFungy(ResultSet rs) throws SQLException {
        Fungy fungy = new Fungy();
        fungy.setId(rs.getLong("id"));
        fungy.setName(rs.getString("name"));
        fungy.setVenomous(rs.getBoolean("venomous"));
        fungy.setFungyImageUrl(rs.getString("fungyImageUrl"));
        fungy.setFungyDescription(rs.getString("fungyDescription"));
        return fungy;
    }
}
