import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

/// Galeri ekranı widget'ı
/// Kullanıcının galeriden fotoğraf seçmesini ve API'ye göndermesini sağlar
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  // API endpoint'i - Kendi IP adresinizi buraya yazın
  static const String apiUrl = 'http://192.168.2.24:5001/predict';

  /// Seçilen fotoğrafı API'ye gönderen fonksiyon
  /// [imagePath]: Seçilen fotoğrafın dosya yolu
  /// 
  /// [context]: BuildContext nesnesi
  Future<void> _sendImageToAPI(String imagePath, BuildContext context) async {
    try {
      // Fotoğrafı base64 formatına çevir
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      debugPrint('API isteği gönderiliyor: $apiUrl');

      // API'ye POST isteği gönder
      final response = await http
          .post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
        }),
      )
          .timeout(
        const Duration(seconds: 10), // 10 saniye timeout süresi
        onTimeout: () {
          throw TimeoutException('Bağlantı zaman aşımına uğradı');
        },
      );

      debugPrint('API yanıt kodu: ${response.statusCode}');
      debugPrint('API yanıtı: ${response.body}');

      // API yanıtını işle ve kullanıcıya göster
      if (context.mounted) {
        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          _showSuccessDialog(context, result); // Başarı dialogu göster
        } else {
          throw Exception(
              'API yanıt vermedi: ${response.statusCode}\nYanıt: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Hata: $e');
      if (context.mounted) {
        _showErrorDialog(context, e.toString()); // Hata dialogu göster
      }
    }
  }

  /// Başarılı işlem sonrası gösterilen dialog
  void _showSuccessDialog(BuildContext context, Map<String, dynamic> result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A0E5F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: const Color(0xFF8B6BFF).withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Başarılı',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Görüntü başarıyla gönderildi.\nBoyut: ${result['size']} bytes',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dialog'u kapat
              Navigator.of(context).pop(); // Galeri ekranını kapat
            },
            child: Text(
              'Tamam',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFF6BE6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Hata durumunda gösterilen dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A0E5F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: const Color(0xFF8B6BFF).withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Hata',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Görüntü gönderilirken bir hata oluştu:\n$errorMessage',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Tamam',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFF6BE6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Galeriden fotoğraf seçme işlemini başlatan fonksiyon
  Future<void> _pickImage(BuildContext context) async {
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
      debugPrint('Hata: $e');
      if (context.mounted) {
        // Fotoğraf seçme hatası dialogu
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A0E5F),
            title: Text(
              'Hata',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Fotoğraf seçilirken bir hata oluştu. Lütfen tekrar deneyin.',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Tamam',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFFF6BE6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A0E5F), // Ana arka plan rengi
      appBar: AppBar(
        title: Text(
          'Galeriden Seç',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ana konteyner
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF3D1B7A)
                        .withOpacity(0.6), // Gradient başlangıç rengi
                    const Color(0xFF2A0E5F)
                        .withOpacity(0.3), // Gradient bitiş rengi
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF8B6BFF).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // İkon konteynerı
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF8B6BFF).withOpacity(0.3),
                          const Color(0xFFFF6BE6).withOpacity(0.3),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      size: 80,
                      color: const Color(0xFFFF6BE6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bilgilendirme metni
                  Text(
                    'Galeriden bir fotoğraf seçin',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Fotoğraf seçme butonu
                  ElevatedButton(
                    onPressed: () => _pickImage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B6BFF).withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Fotoğraf Seç',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
