import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fungi_app/models/fungy.dart';
import 'package:fungi_app/modules/widgets/alert_dialog_widget.dart';
import 'package:fungi_app/modules/widgets/error_dialog.dart';
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
  Future<Fungy?> _sendImageToAPI(String imagePath, BuildContext context) async {
    try {
      debugPrint('Sending API request to: $apiUrl');

      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('API response code: ${response.statusCode}');
      debugPrint('API response: ${response.body}');

      if (!context.mounted) return null;

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
          if (jsonResponse['data'] != null) {
            return Fungy.fromJson(jsonResponse['data']);
          }
        } catch (e) {
          debugPrint('JSON parse error: $e');
          _showErrorDialog('JSON ayrıştırma hatası: $e');
        }
      } else {
        throw Exception(
          'API yanıt vermedi: ${response.statusCode}\nYanıt: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) {
        _showErrorDialog(e.toString());
      }
    }
    return null;
  }

  /// Başarılı işlem sonrası gösterilen dialog
  void showSuccessDialog(Map<String, dynamic> result) {
    String displayMessage = '';
    result.forEach((key, value) {
      displayMessage += '$key: $value\n';
    });
    displayMessage = displayMessage.trimRight();

    Get.dialog(
      AlertDialogWidget(
        action: AppStrings.ok,
        subtitle: displayMessage,
        title: AppStrings.success,
      ),
      barrierDismissible: false,
    );
  }

  /// Hata durumunda gösterilen dialog
  void _showErrorDialog(String message) {
    Get.dialog(
      ErrorDialog(message: message),
      barrierDismissible: false,
    );
  }

  /// Galeriden fotoğraf seçme işlemini başlatan fonksiyon
  Future<Fungy?> pickImage(BuildContext context, {String? imagePath}) async {
    try {
      if (imagePath != null) {
        if (context.mounted) {
          return await _sendImageToAPI(imagePath, context);
        }
      } else {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1024,
          maxHeight: 1024,
        );

        if (image != null && context.mounted) {
          return await _sendImageToAPI(image.path, context);
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) {
        _showErrorDialog('Bir hata oluştu: $e');
      }
    }
    return null;
  }
}
