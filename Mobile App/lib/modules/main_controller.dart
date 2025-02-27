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
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class MainController extends GetxController {
  static const String baseUrl = 'http://192.168.8.5:8080/api/v1';
  static const String apiUrl = '$baseUrl/image/upload';
  final ImagePicker _picker = ImagePicker();
  late final Dio _dio;
  
  @override
  void onInit() {
    super.onInit();
    
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': 'Mozilla/5.0',
        'Accept': '*/*',
      },
    );
    
    _dio = Dio(options);
    
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 1),
      priority: CachePriority.normal,
    );
    
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  String _formatImageUrl(String url) {
    if (url.isEmpty) return url;
    
    debugPrint('Original URL: $url');
    
    try {
      String decodedUrl = url
          .replaceAll('&#x2F;', '/')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#x27;', "'")
          .replaceAll('&#x5C;', '\\');
      
      decodedUrl = Uri.decodeFull(decodedUrl);
      
      if (decodedUrl.contains('github.com') && decodedUrl.contains('/blob/')) {
        final parts = decodedUrl.split('github.com/');
        if (parts.length < 2) return decodedUrl;
        
        final pathParts = parts[1].split('/blob/');
        if (pathParts.length < 2) return decodedUrl;
        
        final repoPath = pathParts[0]; // YunussEmree/Fungify
        final filePath = pathParts[1]; // main/Example Images/...
        
        String rawUrl = 'https://raw.githubusercontent.com/$repoPath/$filePath';
        debugPrint('Formatted URL: $rawUrl');
        return rawUrl;
      }
      
      return decodedUrl;
    } catch (e) {
      debugPrint('URL format hatası: $e');
      return url;
    }
  }
  
  Future<String> validateImageUrl(String imageUrl) async {
    try {
      String formattedUrl = _formatImageUrl(imageUrl);
      
      Uri uri;
      try {
        String noScheme = formattedUrl.replaceFirst(RegExp(r'^https?://'), '');
        
        final parts = noScheme.split('/');
        if (parts.isEmpty) return imageUrl;
        
        final host = parts[0]; // raw.githubusercontent.com
        final path = '/${parts.sublist(1).join('/')}'; // /YunussEmree/Fungify/...
        
        uri = Uri.https(host, path);
        debugPrint('Validated URI: $uri');
      } catch (e) {
        debugPrint('URI oluşturma hatası: $e');
        formattedUrl = formattedUrl
            .replaceAll(' ', '%20')
            .replaceAll('#', '%23')
            .replaceAll('&', '%26');
            
        uri = Uri.parse(formattedUrl);
      }
      
      try {
        final response = await _dio.head(
          uri.toString(),
          options: Options(
            followRedirects: true,
            validateStatus: (status) => status != null && status < 400,
          ),
        );
        
        if (response.statusCode == 200) {
          debugPrint('URL erişilebilir: ${uri.toString()}');
          return uri.toString();
        }
      } catch (e) {
        debugPrint('URL erişim hatası: $e');
      }
      
      try {
        if (imageUrl.contains('github.com')) {
          final githubUrl = imageUrl.trim();
          debugPrint('GitHub Raw URL stratejisi başarısız. Orijinal URL deneniyor: $githubUrl');
          return githubUrl;
        }
      } catch (e) {
        debugPrint('Alternatif URL denemesi başarısız: $e');
      }
      return imageUrl;
    } catch (e) {
      debugPrint('URL doğrulama hatası: $e');
      return imageUrl;
    }
  }

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
          result.fungyImageUrl = await validateImageUrl(result.fungyImageUrl);
          debugPrint('Final Image URL: ${result.fungyImageUrl}');
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
      result.fungyImageUrl = await validateImageUrl(result.fungyImageUrl);
      debugPrint('Final Image URL: ${result.fungyImageUrl}');
      Get.dialog(
        FungyDetailDialog(fungy: result),
        barrierDismissible: false,
      );
    }
  }

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
        debugPrint('API Response: $jsonResponse');
        if (jsonResponse['data'] != null) {
          final fungy = Fungy.fromJson(jsonResponse['data']);
          
          // URL doğrulama işlemi - validateImageUrl metodu ile URL'yi doğrula
          fungy.fungyImageUrl = await validateImageUrl(fungy.fungyImageUrl);
          
          debugPrint('Final Image URL: ${fungy.fungyImageUrl}');
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
      debugPrint('Error in getFungyDetails: $e');
      _showErrorDialog('${AppStrings.generalError} $e');
    } finally {
      setLoading(false);
    }
  }

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
          debugPrint('API Response: $jsonResponse');
          if (jsonResponse['data'] != null) {
            final fungy = Fungy.fromJson(jsonResponse['data']);
            
            fungy.fungyImageUrl = await validateImageUrl(fungy.fungyImageUrl);
            
            debugPrint('Final Image URL: ${fungy.fungyImageUrl}');
            return fungy;
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
      debugPrint('Error in _sendImageToAPI: $e');
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
      debugPrint('Error in pickImage: $e');
      if (context.mounted) {
        _showErrorDialog('${AppStrings.generalError} $e');
      }
    }
    return null;
  }
}
