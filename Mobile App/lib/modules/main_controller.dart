import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fungify/models/fungy.dart';
import 'package:fungify/modules/widgets/alert_dialog_widget.dart';
import 'package:fungify/modules/widgets/error_dialog.dart';
import 'package:fungify/modules/widgets/fungy_detail_dialog.dart';
import 'package:fungify/shared/constants/strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MainController extends GetxController {
  static const String baseUrl = 'http://192.168.8.5:8080/api/v1';
  static const String apiUrl = '$baseUrl/image/upload';
  final ImagePicker _picker = ImagePicker();

  // Image Service Methods
  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        debugPrint('Captured photo: ${photo.path}');
        final result = await pickImage(Get.context!, imagePath: photo.path);
        if (result != null) {
          Get.dialog(
            FungyDetailDialog(fungy: result),
            barrierDismissible: false,
          );
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      _showErrorDialog(AppStrings.errortakingphoto);
    }
  }

  Future<void> selectAndProcessImage() async {
    final result = await pickImage(Get.context!);
    if (result != null) {
      Get.dialog(
        FungyDetailDialog(fungy: result),
        barrierDismissible: false,
      );
    }
  }

  // Fungy Service Methods
  Future<void> getFungyDetails(String name, Function(bool) setLoading) async {
    setLoading(true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/image/find/$name'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        if (jsonResponse['data'] != null) {
          final fungy = Fungy.fromJson(jsonResponse['data']);
          Get.dialog(
            FungyDetailDialog(
              fungy: fungy,
              showProbability: false,
            ),
            barrierDismissible: false,
          );
        }
      } else {
        _showErrorDialog(AppStrings.mushroomDetailsNotFound);
      }
    } catch (e) {
      _showErrorDialog('${AppStrings.generalError} $e');
    } finally {
      setLoading(false);
    }
  }

  // Helper Methods
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
          _showErrorDialog('${AppStrings.jsonParseError} $e');
        }
      } else {
        throw Exception(
          '${AppStrings.apiError} ${response.statusCode}\nYanıt: ${response.body}',
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

  void showSuccessDialog(Map<String, dynamic> result) {
    String displayMessage = '';
    result.forEach((key, value) {
      displayMessage += '$key: $value\n';
    });
    displayMessage = displayMessage.trimRight();

    Get.dialog(
      AlertDialogWidget(
        title: AppStrings.success,
        message: displayMessage,
        buttonText: AppStrings.ok,
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      ErrorDialog(message: message),
      barrierDismissible: false,
    );
  }

  Future<Fungy?> pickImage(BuildContext context, {String? imagePath}) async {
    try {
      if (imagePath != null) {
        if (context.mounted) {
          return await _sendImageToAPI(imagePath, context);
        }
      } else {
        final XFile? image = await _picker.pickImage(
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
        _showErrorDialog('${AppStrings.generalError} $e');
      }
    }
    return null;
  }
}
