import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget Function(BuildContext, String)? placeholderWidget;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
    this.placeholderWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      if (errorWidget != null) {
        return errorWidget!(context, imageUrl, Exception('Empty URL'));
      }
      return SizedBox(
        width: width,
        height: height,
        child: Icon(Icons.broken_image, color: context.ext.colors.primaryDark),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          placeholderWidget ??
          (context, url) => Center(
            child: CustomLoadingIndicator(
              size: (width != null && width! < 50) ? width! * 0.5 : 30,
            ),
          ),
      errorWidget:
          errorWidget ??
          (context, url, error) => SizedBox(
            width: width,
            height: height,
            child: Icon(
              Icons.broken_image,
              color: context.ext.colors.primaryDark,
            ),
          ),
    );
  }
}
