package com.yunussemree.fungify.image;

import java.io.InputStream;
import java.nio.file.*;
import ai.djl.*;
import ai.djl.inference.*;
import ai.djl.modality.*;
import ai.djl.modality.cv.*;
import ai.djl.repository.zoo.*;
import ai.djl.translate.*;
import com.yunussemree.fungify.fungy.Fungy;
import com.yunussemree.fungify.fungy.IFungyService;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;

import java.io.IOException;


@Service
public class ImageServiceImpl implements IImageService {

    IFungyService fungyService;

    public ImageServiceImpl(IFungyService fungyService) {
        this.fungyService = fungyService;
    }



    @Override
    public Fungy predict(MultipartFile file) throws IOException {
        // Path to the directory or file where the model is stored (e.g. TorchScript file)

        String modelDir = "../AI Model/modelcpu.pt";

        Fungy fungy;
        Image image;

        try{
            InputStream inputStream = file.getInputStream();
            image = ImageFactory.getInstance().fromInputStream(inputStream);

        } catch (IOException e) {
            System.out.println("An error occured when reading the image : " + e.getMessage());
            throw new RuntimeException(e);
        }

        Classifications result;

        // Create criteria to load model
        Criteria<Image, Classifications> criteria = Criteria.builder()
                .setTypes(Image.class, Classifications.class)
                .optModelPath(Paths.get(modelDir))
                .optEngine("PyTorch") // Engine you want to use (e.g. PyTorch or TensorFlow)
                .optDevice(Device.cpu()) // Device you want to use (e.g. CPU or GPU)
                .build();

        // Load model and create predictor
        System.out.println("Model is loading...");
        try (ZooModel<Image, Classifications> model = criteria.loadModel();
             Predictor<Image, Classifications> predictor = model.newPredictor()) {

            // Prepare your input data: for example, load an image

            // Run the model to get the prediction
            result = predictor.predict(image);
            System.out.println("Model result: " + result.toString());

            Classifications.Classification bestResult = result.best();
            System.out.println("Best class: " + bestResult.getClassName());
            System.out.println("Probability: " + bestResult.getProbability());

            fungy = fungyService.findByMushroomName(bestResult.getClassName());
            fungy.setProbability(bestResult.getProbability());

        } catch (ModelNotFoundException | MalformedModelException | TranslateException e) {
            System.out.println("An error occured when loading the model : " + e.getMessage());
            throw new RuntimeException(e);
        }
        return fungy;
    }
}
