package com.yunussemree.fungify.image;

import com.yunussemree.fungify.fungy.Fungy;
import com.yunussemree.fungify.fungy.IFungyService;
import com.yunussemree.fungify.utils.api.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("${api.prefix}/image")
public class ImageController {

    private final IImageService imageService;
    private final IFungyService fungyService;

    public ImageController(IImageService imageService, IFungyService fungyServiceImpl) {
        this.imageService = imageService;
        this.fungyService = fungyServiceImpl;
    }

    @PostMapping("/upload")
    public ApiResponse uploadImage(@RequestParam MultipartFile image) {
        if (image.isEmpty()) {
            return ResponseEntity.badRequest().body(new ApiResponse("File is missing", null)).getBody();
        }

        try {
            Fungy prediction = imageService.predict(image);
            return new ApiResponse("Prediction successful", prediction);
        } catch (Exception e) {
            System.out.println("An error occured in prediction : " + e.getMessage());
            return new ApiResponse("Prediction failed", null);
        }

    }

}
