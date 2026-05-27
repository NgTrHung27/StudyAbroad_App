import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

/// Widget bọc Image.network với xử lý lỗi ảnh tự động.
/// Khi URL ảnh không tải được (404, timeout...), tự động hiện ảnh fallback.
class SafeNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? fallback;
  final BorderRadius? borderRadius;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallback,
    this.borderRadius,
  });

  Widget _buildFallback(BuildContext context) {
    if (fallback != null) return fallback!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final logoSize = (size.width * 0.35).clamp(80.0, 160.0);
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A1F36),
                Color(0xFF0F1320),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Subtle radial glow in the centre
              Center(
                child: Container(
                  width: logoSize * 1.8,
                  height: logoSize * 1.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF8B1A1A).withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Logo
              Center(
                child: Opacity(
                  opacity: 0.75,
                  child: Image.asset(
                    ImageAssets.logoRed,
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = url == null || url!.isEmpty
        ? _buildFallback(context)
        : Image.network(
            url!,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) => _buildFallback(context),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey.withValues(alpha: 0.1),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
