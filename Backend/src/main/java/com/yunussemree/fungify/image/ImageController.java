package com.yunussemree.fungify.image;

import com.yunussemree.fungify.fungy.Fungy;
import com.yunussemree.fungify.fungy.IFungyService;
import com.yunussemree.fungify.util.api.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("${api.prefix}/image")
@CrossOrigin(origins = "*")
public class ImageController {

    private final IImageService imageService;
    private final IFungyService fungyService;

    public ImageController(IImageService imageService, IFungyService fungyService) {
        this.imageService = imageService;
        this.fungyService = fungyService;
    }

    @PostMapping("/upload")
    public ResponseEntity<ApiResponse> uploadImage(@RequestParam MultipartFile image) {
        if (image == null || image.isEmpty()) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse("File is missing", null));
        }

        try {
            Fungy prediction = imageService.predict(image);
            return ResponseEntity.ok(new ApiResponse("Prediction successful", prediction));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(new ApiResponse("Prediction failed: " + e.getMessage(), null));
        }
    }

    @GetMapping("/find/{name}")
    public ResponseEntity<ApiResponse> findByName(@PathVariable String name) {
        try {
            if (name == null || name.trim().isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(new ApiResponse("Mushroom name cannot be empty", null));
            }

            Fungy fungy = fungyService.findByMushroomName(name);
            
            if (fungy == null) {
                return ResponseEntity.notFound()
                    .build();
            }

            return ResponseEntity.ok(new ApiResponse("Mushroom found successfully", fungy));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(new ApiResponse("Error finding mushroom: " + e.getMessage(), null));
        }
    }
}
