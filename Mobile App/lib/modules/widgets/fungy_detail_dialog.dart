import 'package:flutter/material.dart';
import 'package:fungify/models/fungy.dart';
import 'package:fungify/modules/widgets/gradient_container.dart';
import 'package:fungify/shared/constants/app_colors.dart';
import 'package:fungify/shared/constants/app_text_styles.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FungyDetailDialog extends StatelessWidget {
  final Fungy fungy;
  final bool showProbability;

  const FungyDetailDialog({
    super.key,
    required this.fungy,
    this.showProbability = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fungy.fungyImageUrl.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: fungy.fungyImageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      httpHeaders: const {
                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
                        'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
                        'Accept-Encoding': 'gzip, deflate, br',
                        'Connection': 'keep-alive',
                        'Cache-Control': 'max-age=0'
                      },
                      maxHeightDiskCache: 300,
                      memCacheWidth: 300,
                      fadeInDuration: const Duration(milliseconds: 300),
                      cacheKey: fungy.fungyImageUrl.contains('github.com') 
                          ? 'github-image-${fungy.id}-${DateTime.now().millisecondsSinceEpoch}'
                          : null,
                      useOldImageOnUrlChange: true,
                      placeholder: (context, url) => Container(
                        height: 200,
                        width: 200,
                        color: AppColors.grey.withAlpha(77),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.highlight,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        debugPrint('Resim yükleme hatası: $url - $error');
                        
                        if (url.contains('github.com') || url.contains('githubusercontent.com')) {
                          Future.delayed(Duration.zero, () => 
                            _loadGitHubImageWithFallback(context, url)
                          );
                        }
                        
                        return Container(
                          height: 200,
                          width: 200,
                          color: AppColors.grey.withAlpha(77),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Resim yüklenemedi',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              _buildDetailRow('İsim:', fungy.name),
              _buildDetailRow('Zehirli:', fungy.venomous ? 'Evet' : 'Hayır'),
              if (showProbability)
                _buildDetailRow('Doğruluk:', '${fungy.probability.toStringAsFixed(2)}%'),
              _buildDetailRow('Açıklama:', fungy.fungyDescription),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text(
                    'Kapat',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.highlight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    String decodedValue = value
        .replaceAll('&#x2F;', '/')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x5C;', '\\');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.button.copyWith(
              color: AppColors.highlight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            decodedValue,
            style: AppTextStyles.body.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _loadGitHubImageWithFallback(BuildContext context, String url) {
    try {
      String decodedUrl = url
          .replaceAll('&#x2F;', '/')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#x27;', "'")
          .replaceAll('&#x5C;', '\\');
          
      if (decodedUrl.contains('github.com') && decodedUrl.contains('/blob/')) {
        String rawUrl = decodedUrl
            .replaceFirst('github.com', 'raw.githubusercontent.com')
            .replaceFirst('/blob/', '/');
        
        debugPrint('Alternatif GitHub URL: $rawUrl');
        
        Image image = Image.network(
          rawUrl,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          headers: const {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
            'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              width: 200,
              color: AppColors.grey.withAlpha(77),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.highlight,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Alternatif resim yükleme hatası: $error');
            return Container(
              height: 200,
              width: 200,
              color: AppColors.grey.withAlpha(77),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Resim yüklenemedi',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        );
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kapat'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('GitHub resmi yükleme hatası: $e');
    }
  }
} 