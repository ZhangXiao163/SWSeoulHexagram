/// API 密钥与配置 — 模板文件
///
/// 使用方式：
///   1. 复制本文件为 secrets.dart
///   2. 填入你的 API Key 和后端地址
///   3. secrets.dart 已在 .gitignore 中，不会误提交
///
/// ```bash
/// cp lib/ai/secrets_template.dart lib/ai/secrets.dart
/// ```
///
/// 【服务器部署】
/// 使用 deploy.sh 脚本自动生成带正确 Key 的 secrets.dart，
/// 或通过 --dart-define 构建时注入：
///   flutter build web --dart-define=GEMINI_API_KEY=xxx \
///                     --dart-define=DEEPSEEK_API_KEY=xxx
class Secrets {
  // ── AI API 密钥 ──
  // 本地开发：在这里填入你的真实 Key
  // 服务器部署：保持 return ''，用 --dart-define 注入
  static String get geminiApiKey {
    const env = String.fromEnvironment('GEMINI_API_KEY');
    if (env.isNotEmpty) return env;
    return ''; // ← 这里填入你的 Gemini API Key
  }

  static String get deepseekApiKey {
    const env = String.fromEnvironment('DEEPSEEK_API_KEY');
    if (env.isNotEmpty) return env;
    return ''; // ← 这里填入你的 DeepSeek API Key
  }

  // ── 后端服务地址 ──
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://15.165.195.197:8080',
  );
}
