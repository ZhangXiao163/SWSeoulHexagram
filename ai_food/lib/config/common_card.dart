import 'package:flutter/material.dart';
import 'app_theme.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? color;
  final double? elevation;

  const CommonCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? AppTheme.surface,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.borderRadius),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.paddingContent),
        child: child,
      ),
    );
  }
}