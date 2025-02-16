package com.yunussemree.fungify.service.impl;

import com.yunussemree.fungify.service.IImageService;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;


@Service
public class ImageServiceImpl implements IImageService {
    @Override
    public Object upload(MultipartFile file) {
        return null;
    }

    /*
    @Override
    public ApiResponse upload(MultipartFile file) {
        try {
            Image image = new Image();
            image.setFileName(file.getOriginalFilename());
            image.setFileType(file.getContentType());
            image.setBlob(new SerialBlob(file.getBytes()));
        } catch (IOException | SQLException e) {
            throw new ImageException(e.getMessage());
        }
        return new ApiResponse("Image uploaded successfully", true); //TODO: return model response
    }

     */

}
