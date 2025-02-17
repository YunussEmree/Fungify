package com.yunussemree.fungify.image;

import com.yunussemree.fungify.fungy.Fungy;
import com.yunussemree.fungify.fungy.IFungyService;
import com.yunussemree.fungify.utils.api.ApiResponse;
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
    public ApiResponse uploadImage(@RequestBody MultipartFile image) {
        /*
        //@RequestParam("mushroomName") String mushroomName
        //Fungy fungy = fungyService.findByMushroomName(mushroomName);

        if (fungy.getName() == null) {
            return new ApiResponse("Mushroom not found", null);
        }
        else {
            return new ApiResponse("Mushroom found", fungy);
        }

         */
        try {
            float[] prediction = imageService.predict(image);
            return new ApiResponse("Prediction successful", prediction);
        } catch (Exception e) {
            return new ApiResponse("Prediction failed", null);
        }

    }

}
