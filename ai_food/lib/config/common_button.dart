import 'package:flutter/material.dart';
import 'app_theme.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool disabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? borderRadius;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.backgroundColor,
    this.textColor,
    this.height = 48,
    this.borderRadius = AppTheme.borderRadiusSmall,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: disabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primary,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(text, style: AppTheme.bodyLarge.copyWith(color: textColor ?? Colors.white)),
      ),
    );
  }

  // 次要按钮
  static Widget secondary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool disabled = false,
  }) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      disabled: disabled,
      backgroundColor: Colors.white,
      textColor: AppTheme.primary,
    );
  }

  // 文字按钮
  static Widget text1({
    required String text,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTheme.bodyMedium.copyWith(color: color ?? AppTheme.primary),
      ),
    );
  }
}