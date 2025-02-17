package com.yunussemree.fungify.image;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface IImageService {

    float[] predict(MultipartFile file) throws IOException;
}
