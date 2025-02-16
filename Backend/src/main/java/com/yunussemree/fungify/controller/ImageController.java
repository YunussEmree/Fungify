package com.yunussemree.fungify.controller;

import com.yunussemree.fungify.service.impl.ImageServiceImpl;
import com.yunussemree.fungify.utils.api.ApiResponse;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("${api.prefix}/image")
public class ImageController {

    private final ImageServiceImpl imageService;

    public ImageController(ImageServiceImpl imageService) {
        this.imageService = imageService;
    }

    @PostMapping("/upload")
    public ApiResponse uploadImage(@RequestBody MultipartFile image) {
        //return imageService.upload(image);
        return null;
    }

}
