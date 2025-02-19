package com.yunussemree.fungify.image;

import java.nio.file.*;
import ai.djl.*;
import ai.djl.inference.*;
import ai.djl.modality.*;
import ai.djl.modality.cv.*;
import ai.djl.repository.zoo.*;
import ai.djl.translate.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;

import java.io.IOException;


@Service
public class ImageServiceImpl implements IImageService {
    Classifications result;

    @Override
    public Classifications predict(MultipartFile file) throws IOException {
        // Path to the directory or file where the model is stored (e.g. TorchScript file)
        String modelDir = "../AI Model/model.pt";
        String imageDir = "../Example Images/Agaricus Bisporus.jpg";

        // Create criteria to load model
        Criteria<Image, Classifications> criteria = Criteria.builder()
                .setTypes(Image.class, Classifications.class)
                .optModelPath(Paths.get(modelDir))
                .optEngine("PyTorch") // Engine you want to use (e.g. PyTorch or TensorFlow)
                .build();

        // Load model and create predictor
        System.out.println("Model is loading...");
        try (ZooModel<Image, Classifications> model = criteria.loadModel();
             Predictor<Image, Classifications> predictor = model.newPredictor()) {

            // Prepare your input data: for example, load an image
            Image image = ImageFactory.getInstance().fromFile(Paths.get(imageDir));

            // Run the model to get the prediction
            Classifications result = predictor.predict(image);
            System.out.println("Model result: " + result.toString());

        } catch (ModelNotFoundException | MalformedModelException | TranslateException e) {
            System.out.println("An error occured when loading the model : " + e.getMessage());
            throw new RuntimeException(e);
        }
        return result;
    }
}
