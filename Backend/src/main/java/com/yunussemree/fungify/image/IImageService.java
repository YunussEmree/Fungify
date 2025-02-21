package com.yunussemree.fungify.image;

import ai.djl.modality.Classifications;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface IImageService {

    String predict(MultipartFile file) throws IOException;
}
