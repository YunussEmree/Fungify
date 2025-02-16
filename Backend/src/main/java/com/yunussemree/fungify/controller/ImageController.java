package com.yunussemree.fungify.controller;

import com.yunussemree.fungify.entity.Fungy;
import com.yunussemree.fungify.service.impl.ImageServiceImpl;
import com.yunussemree.fungify.utils.api.ApiResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


import static com.yunussemree.fungify.repository.DbHelper.findByMushroomName;

@RestController
@RequestMapping("${api.prefix}/image")
public class ImageController {

    private final ImageServiceImpl imageService;

    public ImageController(ImageServiceImpl imageService) {
        this.imageService = imageService;
    }

    @PostMapping("/upload")
    public ApiResponse uploadImage(/*@RequestBody MultipartFile image*/@RequestParam("mushroomName") String mushroomName) {
        Fungy fungy = findByMushroomName(mushroomName);
        ApiResponse apiResponse;
        if(fungy == null) {
            apiResponse = new ApiResponse("Mushroom not found", null);
        } else {
            apiResponse = new ApiResponse("Mushroom found", fungy);
        }
        System.out.println("apiResponse: " + apiResponse);
        return apiResponse;

    }

}
