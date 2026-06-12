import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';

/// 统一 AI 服务 —— 当前后端为 DeepSeek
/// 所有 AI 调用（对话、生成、趋势）统一走这里
class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  static const _baseUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const _model = 'deepseek-chat';

  // ── 单轮生成：给 prompt，返回文本 ──────────────────────
  Future<String> generate({
    required String prompt,
    String? systemPrompt,
    double temperature = 0.8,
    int maxTokens = 512,
  }) async {
    final messages = <Map<String, String>>[];
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      messages.add({'role': 'system', 'content': systemPrompt});
    }
    messages.add({'role': 'user', 'content': prompt});
    return _request(messages, temperature, maxTokens);
  }

  // ── 多轮对话：传入完整消息历史 ──────────────────────
  Future<String> chat({
    required List<Map<String, String>> messages,
    double temperature = 0.8,
    int maxTokens = 512,
  }) async {
    return _request(messages, temperature, maxTokens);
  }

  // ── 核心请求 ─────────────────────────────────────
  Future<String> _request(
    List<Map<String, String>> messages,
    double temperature,
    int maxTokens,
  ) async {
    final body = jsonEncode({
      'model': _model,
      'messages': messages,
      'temperature': temperature,
      'max_tokens': maxTokens,
    });

    // 🔍 打印发给 AI 的完整请求
    debugPrint('╔══ 🔍 [AI请求] 发给 DeepSeek 的消息 ══');
    for (int i = 0; i < messages.length; i++) {
      final m = messages[i];
      final role = m['role'] ?? '?';
      final content = m['content'] ?? '';
      final preview = content.length > 150 ? '${content.substring(0, 150)}...' : content;
      debugPrint('║  [$i] $role: $preview');
    }
    debugPrint('╚══ 共 ${messages.length} 条消息，max_tokens=$maxTokens ══');

    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Secrets.deepseekApiKey}',
      },
      body: body,
    );

    if (res.statusCode != 200) {
      debugPrint('❌ [AI错误] HTTP ${res.statusCode}: ${res.body}');
      throw Exception('DeepSeek API ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body);
    final text = data['choices'][0]['message']['content'] as String;

    // 🔍 打印 AI 返回的原始内容
    debugPrint('╔══ 🤖 [AI回复] ══');
    debugPrint('║  $text');
    debugPrint('╚══');

    return text;
  }
}
