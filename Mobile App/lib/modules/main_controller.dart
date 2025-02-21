import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fungi_app/modules/widgets/alert_dialog_widget.dart';
import 'package:fungi_app/shared/constants/strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MainController extends GetxController {
  // API endpoint'i - Kendi IP adresinizi buraya yazın
  static const String apiUrl = 'http://10.20.28.96:8080/api/v1/image/upload';

  /// Seçilen fotoğrafı API'ye gönderen fonksiyon
  /// [imagePath]: Seçilen fotoğrafın dosya yolu
  /// [context]: BuildContext nesnesi
  Future<void> _sendImageToAPI(String imagePath, BuildContext context) async {
    try {
      debugPrint('API isteği gönderiliyor: $apiUrl');

      // API'ye POST isteği gönder
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('API yanıt kodu: ${response.statusCode}');
      debugPrint('API yanıtı: ${response.body}');

      // API yanıtını işle ve kullanıcıya göster
      if (context.mounted) {
        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          showSuccessDialog(context, result); // Başarı dialogu göster
        } else {
          throw Exception(
              'API yanıt vermedi: ${response.statusCode}\nYanıt: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Hata: $e');
      if (context.mounted) {
        showErrorDialog(context, e.toString()); // Hata dialogu göster
      }
    }
  }

  /// Başarılı işlem sonrası gösterilen dialog
  void showSuccessDialog(BuildContext context, Map<String, dynamic> result) {
    Get.dialog(
        AlertDialogWidget(
            action: AppStrings.OK,
            subtitle: '${AppStrings.IMAGESENTSUCCESS} $result',
            title: AppStrings.SUCCESS),
        barrierDismissible: false);
  }

  /// Hata durumunda gösterilen dialog
  void showErrorDialog(BuildContext context, String errorMessage) {
    Get.dialog(
        AlertDialogWidget(
            action: AppStrings.OK,
            subtitle: '${AppStrings.ERRORSENDINGPHOTO} $errorMessage',
            title: AppStrings.ERROR),
        barrierDismissible: false);
  }

  /// Galeriden fotoğraf seçme işlemini başlatan fonksiyon
  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      // Galeriden fotoğraf seç
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Fotoğraf kalitesi
      );

      if (image != null && context.mounted) {
        await _sendImageToAPI(image.path, context);
      }
    } catch (e) {
      debugPrint('${AppStrings.ERROR}: $e');
      if (context.mounted) {
        // Fotoğraf seçme hatası dialogu
        Get.dialog(
            AlertDialogWidget(
                action: AppStrings.OK,
                subtitle: AppStrings.ERRORTAKINGPHOTO,
                title: AppStrings.ERROR),
            barrierDismissible: false);
      }
    }
  }
}
