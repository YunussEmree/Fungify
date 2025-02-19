package com.yunussemree.fungify.image;

import java.nio.file.*;
import java.awt.image.*;
import ai.djl.*;
import ai.djl.inference.*;
import ai.djl.modality.*;
import ai.djl.modality.cv.*;
import ai.djl.modality.cv.util.*;
import ai.djl.modality.cv.transform.*;
import ai.djl.modality.cv.translator.*;
import ai.djl.repository.zoo.*;
import ai.djl.translate.*;
import ai.djl.training.util.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;


@Service
public class ImageServiceImpl implements IImageService {
    private final String modelPath = "../AI Model/model.pt";

    @Override
    public float[] predict(MultipartFile file) throws IOException {
        float[] imageData = convertMultipartFileToFloatArray(file);


        /*Criteria<image, classifications=""> criteria = Criteria.builder()
                .setTypes(Image.class, Classifications.class)
                .optModelPath(Paths.get("build/pytorch_models/resnet18"))
                .optOption("mapLocation", "true") // this model requires mapLocation for GPU
                .optTranslator(translator)
                .optProgress(new ProgressBar()).build();

        ZooModel model = criteria.loadModel();

         */
        return null;

    }

    public static float[] convertMultipartFileToFloatArray(MultipartFile file) throws IOException {
        byte[] bytes = file.getBytes();
        int numFloats = bytes.length / Float.BYTES; // 4 bytes per float
        float[] floatArray = new float[numFloats];

        ByteBuffer byteBuffer = ByteBuffer.wrap(bytes);
        byteBuffer.order(ByteOrder.LITTLE_ENDIAN); // Adjust if needed (Big Endian)

        for (int i = 0; i < numFloats; i++) {
            floatArray[i] = byteBuffer.getFloat();
        }

        return floatArray;
    }

}
