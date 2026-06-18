import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ai_food/ai/secrets.dart';

/// 统一 AI 服务 — 直接调用 DeepSeek API
class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  static const String _baseUrl = 'https://api.deepseek.com/v1/chat/completions';

  // ── 单轮生成：给 prompt，返回文本 ──────────────────────
  Future<String> generate({
    required String prompt,
    String? systemPrompt,
    double temperature = 0.8,
    int maxTokens = 512,
  }) async {
    final messages = <Map<String, String>>[
      if (systemPrompt != null && systemPrompt.isNotEmpty)
        {'role': 'system', 'content': systemPrompt},
      {'role': 'user', 'content': prompt},
    ];

    return _callDeepSeek(messages, temperature, maxTokens);
  }

  // ── 多轮对话：传入完整消息历史 ──────────────────────
  Future<String> chat({
    required List<Map<String, String>> messages,
    double temperature = 0.8,
    int maxTokens = 512,
  }) async {
    return _callDeepSeek(messages, temperature, maxTokens);
  }

  // ── 核心调用 ────────────────────────────────────────
  Future<String> _callDeepSeek(
    List<Map<String, String>> messages,
    double temperature,
    int maxTokens,
  ) async {
    final body = <String, dynamic>{
      'model': 'deepseek-chat',
      'messages': messages,
      'temperature': temperature,
      'max_tokens': maxTokens,
    };

    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Secrets.deepseekApiKey}',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      debugPrint('╔══ ❌ [DeepSeek API错误] ══');
      debugPrint('║  HTTP ${res.statusCode}: ${res.body}');
      debugPrint('╚══');
      throw Exception('DeepSeek API 错误: HTTP ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final choices = data['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('DeepSeek API 返回空结果');
    }

    final text = choices[0]['message']['content'] as String? ?? '';

    debugPrint('╔══ 🤖 [DeepSeek回复] ══');
    debugPrint('║  $text');
    debugPrint('╚══');

    return text;
  }
}
