import 'package:flutter/material.dart';

class PortfolioLogo extends StatelessWidget {
  static const String imageUrl =
      'https://drive.google.com/thumbnail?id=19o0-cXysNK5HsufGJJSZThSlPpuury__&sz=w1000';

  final double size;
  final BorderRadius? borderRadius;

  const PortfolioLogo({
    super.key,
    this.size = 40,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(size * .28);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: size,
        height: size,
        color: colors.surfaceContainerHigh,
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.code_rounded,
              size: size * .55,
              color: colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
