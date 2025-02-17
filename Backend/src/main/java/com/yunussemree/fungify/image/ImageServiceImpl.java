package com.yunussemree.fungify.image;

import org.pytorch.IValue;
import org.pytorch.Module;
import org.pytorch.Tensor;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;


@Service
public class ImageServiceImpl implements IImageService {
    private final String modelPath = "../AI Model/model.pt";
    private final org.pytorch.Module model = Module.load(modelPath);

    @Override
    public float[] predict(MultipartFile file) throws IOException {
        float[] imageData = convertMultipartFileToFloatArray(file);

        Tensor inputTensor = Tensor.fromBlob(imageData, new long[]{1, 3, 128, 128});
        Tensor outputTensor = model.forward(IValue.from(inputTensor)).toTensor();

        float[] result = outputTensor.getDataAsFloatArray();

        for(float score : result) { //TODO:??
            System.out.println(score);
        }
        return result;
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
