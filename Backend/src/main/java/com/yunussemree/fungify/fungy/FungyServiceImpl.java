package com.yunussemree.fungify.fungy;

import com.yunussemree.fungify.exception.DatabaseException;
import com.yunussemree.fungify.util.security.SqlSecurityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class FungyServiceImpl implements IFungyService {

    private static final String FIND_BY_NAME_QUERY = "SELECT * FROM fungies WHERE name = ?";
    private static final String FIND_ALL_QUERY = "SELECT * FROM fungies";
    
    private final DataSource dataSource;
    private final SqlSecurityUtil securityUtil;
    
    @Autowired
    public FungyServiceImpl(DataSource dataSource, SqlSecurityUtil securityUtil) {
        this.dataSource = dataSource;
        this.securityUtil = securityUtil;
    }

    @Override
    public Fungy findByMushroomName(String mushroomName) {
        // Validate input to prevent SQL injection
        if (!securityUtil.validateInput(mushroomName)) {
            throw new IllegalArgumentException("Invalid mushroom name");
        }
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(FIND_BY_NAME_QUERY)) {
            
            // Use prepared statement for safe parameter binding
            pstmt.setString(1, mushroomName);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFungy(rs);
                }
            }
        } catch (SQLException e) {
            throw DatabaseException.createSecure(
                "Error finding mushroom by name: " + e.getMessage(),
                "Unable to retrieve mushroom data. Please try again later.",
                e
            );
        }
        return null;
    }
    
    @Override
    public List<Fungy> findAll() {
        List<Fungy> fungyList = new ArrayList<>();
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(FIND_ALL_QUERY);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                fungyList.add(mapResultSetToFungy(rs));
            }
        } catch (SQLException e) {
            throw DatabaseException.createSecure(
                "Error finding all mushrooms: " + e.getMessage(), 
                "Unable to retrieve mushroom data. Please try again later.",
                e
            );
        }
        
        return fungyList;
    }

    private Fungy mapResultSetToFungy(ResultSet rs) throws SQLException {
        Fungy fungy = new Fungy();
        fungy.setId(rs.getLong("id"));
        fungy.setName(rs.getString("name"));
        fungy.setVenomous(rs.getBoolean("venomous"));
        fungy.setFungyImageUrl(rs.getString("fungyImageUrl"));
        fungy.setFungyDescription(rs.getString("fungyDescription"));
        
        // Encode outputs to prevent XSS attacks
        fungy.setName(securityUtil.encodeForOutput(fungy.getName()));

        // fungy.setFungyImageUrl(securityUtil.encodeForOutput(fungy.getFungyImageUrl()));
        fungy.setFungyDescription(securityUtil.encodeForOutput(fungy.getFungyDescription()));
        
        return fungy;
    }
}
