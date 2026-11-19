import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RouteCover extends StatelessWidget {
  const RouteCover({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final String asset;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      filterQuality: FilterQuality.high,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) {
        return const ColoredBox(
          color: AppColors.mist,
          child: Center(
            child: Icon(
              Icons.landscape_outlined,
              color: AppColors.pine,
              size: 34,
            ),
          ),
        );
      },
    );
  }
}
