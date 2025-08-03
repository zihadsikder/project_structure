import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UniversalImage extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;
  final double borderRadius;
  final bool isCircular;
  final BoxFit fit;

  /// Constructor
  const UniversalImage({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.borderRadius = 100,
    this.isCircular = false, // NEW
    this.fit = BoxFit.cover,
  });

  bool get _isSvg => imagePath?.toLowerCase().endsWith('.svg') ?? false;
  bool get _isNetwork => imagePath?.startsWith('http') ?? false;
  bool get _isAsset => !_isNetwork && !_isSvg && imagePath != null;

  static const String defaultPlaceholder =
      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imagePath == null || imagePath!.isEmpty) {
      imageWidget = _buildNetworkImage(defaultPlaceholder);
    } else if (_isSvg) {
      imageWidget = _buildSvgImage(imagePath!);
    } else if (_isNetwork) {
      imageWidget = _buildNetworkImage(imagePath!);
    } else if (_isAsset) {
      imageWidget = Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildNetworkImage(defaultPlaceholder),
      );
    } else {
      imageWidget = _buildNetworkImage(defaultPlaceholder);
    }

    return ClipRRect(
      borderRadius: isCircular
          ? BorderRadius.circular((height ?? width ?? 50) / 2)
          : BorderRadius.circular(borderRadius),
      child: imageWidget,
    );
  }

  Widget _buildSvgImage(String url) {
    try {
      return SvgPicture.asset(
        url,
        height: height,
        width: width,
        fit: fit,
        placeholderBuilder: (_) => _defaultLoadingPlaceholder(),
      );
    } catch (e) {
      return _buildNetworkImage(defaultPlaceholder);
    }
  }

  Widget _buildNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      placeholder: (_, __) => _defaultLoadingPlaceholder(),
      errorWidget: (_, __, ___) => Image.network(
        defaultPlaceholder,
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }

  Widget _defaultLoadingPlaceholder() {
    return SizedBox(
      height: height ?? 38,
      width: width ?? 38,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}



///1. Network Image
// UniversalImage(
// imagePath: 'https://example.com/image.jpg',
// height: 60,
// width: 60,
// borderRadius: 12,
//   isCircular: true,
// )

///2. Asset Image

// UniversalImage(
// imagePath: 'assets/images/local_image.png',
// height: 40,
// width: 40,
// )

///3. SVG Asset

// UniversalImage(
// imagePath: 'assets/icons/icon.svg',
// height: 24,
// width: 24,
// fit: BoxFit.contain,
// )

///4. No Image

// UniversalImage(
// imagePath: '',
// height: 50,
// width: 50,
// )
