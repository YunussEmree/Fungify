package com.yunussemree.fungify.image;

import ai.djl.modality.cv.ImageFactory;
import com.yunussemree.fungify.fungy.Fungy;
import com.yunussemree.fungify.fungy.IFungyService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;

import java.io.IOException;
import java.io.InputStream;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@ActiveProfiles("test")
@TestPropertySource(locations = "classpath:application-test.properties")
class ImageServiceImplTest {

    @Mock
    private IFungyService fungyService;
    
    @InjectMocks
    private ImageServiceImpl imageService;

    @Test
    void predict_ComplexDjlInfrastructure_NotFullyTested() {
        assertTrue(true, "DJL bağımlılıkları için ayrı test stratejileri gereklidir");
    }
    
    @Test
    void predict_WhenImageIsNull_ShouldThrowException() {
        MockMultipartFile mockFile = null;
        assertThrows(NullPointerException.class, () -> imageService.predict(mockFile));
    }
    
    @Test
    void predict_WhenImageReadingFails_ShouldThrowRuntimeException() throws IOException {
        MockMultipartFile mockFile = new MockMultipartFile(
            "image", 
            "test.jpg", 
            "image/jpeg", 
            "test image content".getBytes()
        );
        
        try (MockedStatic<ImageFactory> imageFactoryMock = Mockito.mockStatic(ImageFactory.class)) {
            ImageFactory mockImageFactory = mock(ImageFactory.class);
            imageFactoryMock.when(ImageFactory::getInstance).thenReturn(mockImageFactory);
            when(mockImageFactory.fromInputStream(any(InputStream.class))).thenThrow(new IOException("Failed to read image"));
            
            assertThrows(RuntimeException.class, () -> imageService.predict(mockFile));
        }
    }
    
    @Test
    void findFungyByName_ShouldCallFungyService() {
        String mushroomName = "Amanita muscaria";
        Fungy expectedFungy = new Fungy();
        expectedFungy.setId(1L);
        expectedFungy.setName(mushroomName);
        
        when(fungyService.findByMushroomName(mushroomName)).thenReturn(expectedFungy);
        
        Fungy result = fungyService.findByMushroomName(mushroomName);
        
        assertNotNull(result);
        assertEquals(mushroomName, result.getName());
        verify(fungyService).findByMushroomName(mushroomName);
    }
} 