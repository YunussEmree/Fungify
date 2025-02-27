package com.yunussemree.fungify.image;

import com.yunussemree.fungify.fungy.Fungy;
import com.yunussemree.fungify.fungy.IFungyService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.io.IOException;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ImageController.class)
@TestPropertySource(locations = "classpath:application-test.properties")
@ActiveProfiles("test")
class ImageControllerTest {

    @MockBean
    private IImageService imageService;

    @MockBean
    private IFungyService fungyService;

    @Autowired
    private MockMvc mockMvc;

    @Test
    void uploadImage_WhenValidImage_ShouldReturnOk() throws Exception {
        MockMultipartFile mockImage = new MockMultipartFile(
                "image", 
                "test.jpg", 
                MediaType.IMAGE_JPEG_VALUE, 
                "test image content".getBytes()
        );
        
        Fungy mockFungy = new Fungy();
        mockFungy.setId(1L);
        mockFungy.setName("Amanita muscaria");
        mockFungy.setVenomous(true);
        mockFungy.setProbability(0.95);
        mockFungy.setFungyImageUrl("http://example.com/image.jpg");
        mockFungy.setFungyDescription("A poisonous mushroom");
        
        when(imageService.predict(any())).thenReturn(mockFungy);

        mockMvc.perform(multipart("/api/v1/image/upload")
                .file(mockImage))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Prediction successful"))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.name").value("Amanita muscaria"))
                .andExpect(jsonPath("$.data.venomous").value(true))
                .andExpect(jsonPath("$.data.probability").value(0.95))
                .andExpect(jsonPath("$.data.fungyImageUrl").value("http://example.com/image.jpg"))
                .andExpect(jsonPath("$.data.fungyDescription").value("A poisonous mushroom"));
    }
    
    @Test
    void uploadImage_WhenImageIsEmpty_ShouldReturnBadRequest() throws Exception {
        MockMultipartFile mockImage = new MockMultipartFile(
                "image", 
                "", 
                MediaType.IMAGE_JPEG_VALUE, 
                new byte[0]
        );

        mockMvc.perform(multipart("/api/v1/image/upload")
                .file(mockImage))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("File is missing"))
                .andExpect(jsonPath("$.data").isEmpty());
    }
    
    @Test
    void uploadImage_WhenPredictionFails_ShouldReturnInternalServerError() throws Exception {
        MockMultipartFile mockImage = new MockMultipartFile(
                "image", 
                "test.jpg", 
                MediaType.IMAGE_JPEG_VALUE, 
                "test image content".getBytes()
        );
        
        when(imageService.predict(any())).thenThrow(new IOException("Failed to process image"));

        mockMvc.perform(multipart("/api/v1/image/upload")
                .file(mockImage))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.message").value("Prediction failed: Failed to process image"))
                .andExpect(jsonPath("$.data").isEmpty());
    }
    
    @Test
    void findByName_WhenMushroomExists_ShouldReturnOk() throws Exception {
        String mushroomName = "Amanita muscaria";
        
        Fungy mockFungy = new Fungy();
        mockFungy.setId(1L);
        mockFungy.setName(mushroomName);
        mockFungy.setVenomous(true);
        mockFungy.setFungyImageUrl("http://example.com/image.jpg");
        mockFungy.setFungyDescription("A poisonous mushroom");
        
        when(fungyService.findByMushroomName(mushroomName)).thenReturn(mockFungy);

        mockMvc.perform(get("/api/v1/image/find/{name}", mushroomName)
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Mushroom found successfully"))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.name").value(mushroomName))
                .andExpect(jsonPath("$.data.venomous").value(true))
                .andExpect(jsonPath("$.data.fungyImageUrl").value("http://example.com/image.jpg"))
                .andExpect(jsonPath("$.data.fungyDescription").value("A poisonous mushroom"));
    }
    
    @Test
    void findByName_WhenMushroomNameIsEmpty_ShouldReturnBadRequest() throws Exception {
        mockMvc.perform(get("/api/v1/image/find/{name}", " ")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Mushroom name cannot be empty"))
                .andExpect(jsonPath("$.data").isEmpty());
    }
    
    @Test
    void findByName_WhenMushroomDoesNotExist_ShouldReturnNotFound() throws Exception {
        String mushroomName = "NonExistentMushroom";
        
        when(fungyService.findByMushroomName(mushroomName)).thenReturn(null);

        mockMvc.perform(get("/api/v1/image/find/{name}", mushroomName)
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }
    
    @Test
    void findByName_WhenExceptionOccurs_ShouldReturnInternalServerError() throws Exception {
        String mushroomName = "Amanita muscaria";
        
        when(fungyService.findByMushroomName(anyString())).thenThrow(new RuntimeException("Database error"));

        mockMvc.perform(get("/api/v1/image/find/{name}", mushroomName)
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.message").value("Error finding mushroom: Database error"))
                .andExpect(jsonPath("$.data").isEmpty());
    }
} 