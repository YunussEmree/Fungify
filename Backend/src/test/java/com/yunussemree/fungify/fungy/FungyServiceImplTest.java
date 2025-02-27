package com.yunussemree.fungify.fungy;

import com.yunussemree.fungify.exception.DatabaseException;
import com.yunussemree.fungify.util.security.SecurityLogger;
import com.yunussemree.fungify.util.security.SqlSecurityUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.contains;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class FungyServiceImplTest {

    @Mock
    private DataSource mockDataSource;
    
    @Mock
    private SecurityLogger mockSecurityLogger;
    
    @Mock
    private Connection mockConnection;
    
    @Mock
    private PreparedStatement mockPreparedStatement;
    
    @Mock
    private ResultSet mockResultSet;
    
    private SqlSecurityUtil sqlSecurityUtil;
    private FungyServiceImpl fungyService;
    
    @BeforeEach
    void setUp() throws SQLException {
        DatabaseException.setSecurityLogger(mockSecurityLogger);

        sqlSecurityUtil = spy(new SqlSecurityUtil(mockSecurityLogger));

        doReturn(true).when(sqlSecurityUtil).validateInput(anyString());

        doAnswer(invocation -> invocation.getArgument(0)).when(sqlSecurityUtil).encodeForOutput(anyString());

        fungyService = new FungyServiceImpl(mockDataSource, sqlSecurityUtil);

        when(mockDataSource.getConnection()).thenReturn(mockConnection);
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);

        doNothing().when(mockSecurityLogger).logWarning(anyString());
        doNothing().when(mockSecurityLogger).logSecurityBreach(anyString(), anyString());
        doNothing().when(mockSecurityLogger).logInfo(anyString());
        doNothing().when(mockSecurityLogger).logError(anyString(), any(Throwable.class));
    }

    @Test
    void findByMushroomName_WhenMushroomExists_ShouldReturnFungy() throws SQLException {
        String mushroomName = "AmanitaMuscaria";
        
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);

        when(mockResultSet.getLong("id")).thenReturn(1L);
        when(mockResultSet.getString("name")).thenReturn(mushroomName);
        when(mockResultSet.getBoolean("venomous")).thenReturn(true);
        when(mockResultSet.getString("fungyImageUrl")).thenReturn("http://example.com/image.jpg");
        when(mockResultSet.getString("fungyDescription")).thenReturn("A poisonous mushroom");

        Fungy result = fungyService.findByMushroomName(mushroomName);

        assertNotNull(result);
        assertEquals(1L, result.getId());
        assertEquals(mushroomName, result.getName());
        assertTrue(result.isVenomous());
        assertEquals("http://example.com/image.jpg", result.getFungyImageUrl());
        assertEquals("A poisonous mushroom", result.getFungyDescription());

        verify(sqlSecurityUtil).validateInput(mushroomName);
        verify(mockPreparedStatement).setString(1, mushroomName);
        verify(mockPreparedStatement).executeQuery();
        verify(mockResultSet).next();
    }
    
    @Test
    void findByMushroomName_WhenMushroomDoesNotExist_ShouldReturnNull() throws SQLException {
        String mushroomName = "NonExistentMushroom";
        
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false);

        Fungy result = fungyService.findByMushroomName(mushroomName);

        assertNull(result);

        verify(sqlSecurityUtil).validateInput(mushroomName);
        verify(mockPreparedStatement).setString(1, mushroomName);
        verify(mockPreparedStatement).executeQuery();
        verify(mockResultSet).next();
    }
    
    @Test
    void findByMushroomName_WhenSQLExceptionOccurs_ShouldThrowDatabaseException() throws SQLException {
        String mushroomName = "AmanitaMuscaria";
        SQLException sqlException = new SQLException("Database error");
        
        when(mockPreparedStatement.executeQuery()).thenThrow(sqlException);

        Exception exception = assertThrows(DatabaseException.class, 
                () -> fungyService.findByMushroomName(mushroomName));
        assertEquals(sqlException, exception.getCause());

        verify(mockSecurityLogger).logError(contains("Database error"), eq(sqlException));
    }
    
    @Test
    void findByMushroomName_WhenInvalidInput_ShouldThrowIllegalArgumentException() throws SQLException {
        String maliciousInput = "'; DROP TABLE fungies; --";

        doReturn(false).when(sqlSecurityUtil).validateInput(maliciousInput);

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, 
                () -> fungyService.findByMushroomName(maliciousInput));
        assertEquals("Invalid mushroom name", exception.getMessage());

        verify(sqlSecurityUtil).validateInput(maliciousInput);

        verify(mockDataSource, never()).getConnection();
        verifyNoMoreInteractions(mockPreparedStatement, mockResultSet);
    }
    
    @Test
    void findAll_ShouldReturnAllFungies() throws SQLException {
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, true, false);

        when(mockResultSet.getLong("id")).thenReturn(1L, 2L);
        when(mockResultSet.getString("name")).thenReturn("AmanitaMuscaria", "BoletusEdulis");
        when(mockResultSet.getBoolean("venomous")).thenReturn(true, false);
        when(mockResultSet.getString("fungyImageUrl")).thenReturn("url1", "url2");
        when(mockResultSet.getString("fungyDescription")).thenReturn("desc1", "desc2");

        List<Fungy> results = fungyService.findAll();

        assertEquals(2, results.size());
        assertEquals("AmanitaMuscaria", results.get(0).getName());
        assertEquals("BoletusEdulis", results.get(1).getName());

        verify(sqlSecurityUtil, times(6)).encodeForOutput(anyString());
    }
} 