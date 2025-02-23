package com.yunussemree.fungify.image;

import com.yunussemree.fungify.fungy.Fungy;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface IImageService {

    Fungy predict(MultipartFile file) throws IOException;
}
