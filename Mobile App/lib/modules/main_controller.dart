import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fungi_app/modules/widgets/alert_dialog_widget.dart';
import 'package:fungi_app/shared/constants/strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MainController extends GetxController {
  // API endpoint'i - Kendi IP adresinizi buraya yazın
  static const String apiUrl = 'http://192.168.8.5:8080/api/v1/image/upload';

  /// Seçilen fotoğrafı API'ye gönderen fonksiyon
  /// [imagePath]: Seçilen fotoğrafın dosya yolu
  /// [context]: BuildContext nesnesi
  Future<void> _sendImageToAPI(String imagePath, BuildContext context) async {
    try {
      debugPrint('Sending API request to: $apiUrl');

      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('API response code: ${response.statusCode}');
      debugPrint('API response: ${response.body}');

      if (!context.mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final result = jsonDecode(response.body);
          if (context.mounted) {
            showSuccessDialog(context, result);
          }
        } catch (e) {
          debugPrint('JSON parse error: $e');
          if (context.mounted) {
            showSuccessDialog(context, {'message': response.body});
          }
        }
      } else {
        throw Exception(
          'API failed to respond: ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  /// Başarılı işlem sonrası gösterilen dialog
  void showSuccessDialog(BuildContext context, Map<String, dynamic> result) {
    String displayMessage = '';
    
    // API yanıtındaki tüm alanları göster
    result.forEach((key, value) {
      displayMessage += '$key: $value\n';
    });

    // Son satırdaki fazla \n karakterini kaldır
    displayMessage = displayMessage.trimRight();

    Get.dialog(
      AlertDialogWidget(
        action: AppStrings.OK,
        subtitle: displayMessage,
        title: AppStrings.SUCCESS,
      ),
      barrierDismissible: false,
    );
  }

  /// Hata durumunda gösterilen dialog
  void showErrorDialog(BuildContext context, String errorMessage) {
    Get.dialog(
      AlertDialogWidget(
        action: AppStrings.OK,
        subtitle: errorMessage,
        title: AppStrings.ERROR,
      ),
      barrierDismissible: false,
    );
  }

  /// Galeriden fotoğraf seçme işlemini başlatan fonksiyon
  Future<void> pickImage(BuildContext context, {String? imagePath}) async {
    try {
      if (imagePath != null) {
        if (context.mounted) {
          await _sendImageToAPI(imagePath, context);
        }
      } else {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null && context.mounted) {
          await _sendImageToAPI(image.path, context);
        }
      }
    } catch (e) {
      debugPrint('${AppStrings.ERROR}: $e');
      if (context.mounted) {
        Get.dialog(
          AlertDialogWidget(
            action: AppStrings.OK,
            subtitle: AppStrings.ERRORTAKINGPHOTO,
            title: AppStrings.ERROR,
          ),
          barrierDismissible: false,
        );
      }
    }
  }
}
