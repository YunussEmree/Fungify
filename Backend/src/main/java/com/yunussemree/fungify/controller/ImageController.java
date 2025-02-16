package com.yunussemree.fungify.controller;

import com.yunussemree.fungify.entity.Fungy;
import com.yunussemree.fungify.service.IFungyService;
import com.yunussemree.fungify.service.IImageService;
import com.yunussemree.fungify.utils.api.ApiResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
    public ApiResponse uploadImage(/*@RequestBody MultipartFile image*/@RequestParam("mushroomName") String mushroomName) {
        Fungy fungy = fungyService.findByMushroomName(mushroomName);

        if (fungy.getName() == null) {
            return new ApiResponse("Mushroom not found", null);
        }
        else {
            return new ApiResponse("Mushroom found", fungy);
        }
    }

}
