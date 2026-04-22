import 'package:flutter/material.dart';

class AppTheme {
  // ---------------- 统一颜色系统 ----------------
  static const Color primary = Color(0xFF1677FF);       // 主色
  static const Color primaryLight = Color(0xFFE6F0FF); // 主色浅版
  static const Color secondary = Color(0xFF6C727F);     // 次要色
  static const Color background = Color(0xFFF5F7FA);    // 页面背景
  static const Color surface = Colors.white;            // 卡片/组件背景
  static const Color textPrimary = Color(0xFF1D2129);   // 主文本
  static const Color textSecondary = Color(0xFF4E5969); // 次要文本
  static const Color textHint = Color(0xFF86909C);      // 提示文本
  static const Color divider = Color(0xFFE5E6EB);       // 分割线
  static const Color success = Color(0xFF00B42A);       // 成功色
  static const Color warning = Color(0xFFFF7D00);       // 警告色
  static const Color error = Color(0xFFF53F3F);         // 错误色

  // ---------------- 统一文字样式 ----------------
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle hintStyle = TextStyle(
    fontSize: 14,
    color: textHint,
    height: 1.5,
  );

  // ---------------- 统一尺寸/间距 ----------------
  static const double borderRadius = 12;
  static const double borderRadiusSmall = 8;
  static const double borderRadiusLarge = 16;

  static const double paddingPage = 16;
  static const double paddingContent = 12;
  static const double paddingSmall = 8;

  static const double spaceSmall = 8;
  static const double spaceMedium = 16;
  static const double spaceLarge = 24;

  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 20;
  static const double iconSizeLarge = 24;

  // ---------------- 生成ThemeData ----------------
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        background: background,
        surface: surface,
        error: error,
      ),
      textTheme: const TextTheme(
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        titleTextStyle: titleMedium,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingContent,
          vertical: paddingSmall,
        ),
      ),
    );
  }
}