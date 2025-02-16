package com.yunussemree.fungify.service;

import org.springframework.web.multipart.MultipartFile;

public interface IImageService {

    Object upload(MultipartFile file);
}
