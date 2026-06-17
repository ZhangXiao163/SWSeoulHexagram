import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ai_food/service/api_service.dart';

/// 统一 AI 服务 — 所有 AI 调用通过后端代理转发，
/// API Key 只存在于服务器端，不暴露给客户端
class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;
  AiService._internal();

  /// 后端 AI 代理地址
  String get _proxyBase => '${ApiService().baseUrl}/ai';

  // ── 单轮生成：给 prompt，返回文本 ──────────────────────
  Future<String> generate({
    required String prompt,
    String? systemPrompt,
    double temperature = 0.8,
    int maxTokens = 512,
  }) async {
    final body = <String, dynamic>{
      'prompt': prompt,
      'temperature': temperature,
      'max_tokens': maxTokens,
    };
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      body['systemPrompt'] = systemPrompt;
    }

    final res = await http.post(
      Uri.parse('$_proxyBase/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('AI 代理错误: HTTP ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['sysCode'] != '0000') {
      throw Exception(data['sysMessage'] ?? 'AI 代理调用失败');
    }

    final result = data['data'] as Map<String, dynamic>;
    final text = result['content'] as String? ?? '';

    debugPrint('╔══ 🤖 [AI代理回复] ══');
    debugPrint('║  $text');
    debugPrint('╚══');

    return text;
  }

  // ── 多轮对话：传入完整消息历史 ──────────────────────
  Future<String> chat({
    required List<Map<String, String>> messages,
    double temperature = 0.8,
    int maxTokens = 512,
  }) async {
    final body = <String, dynamic>{
      'messages': messages,
      'temperature': temperature,
      'max_tokens': maxTokens,
    };

    final res = await http.post(
      Uri.parse('$_proxyBase/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('AI 代理错误: HTTP ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['sysCode'] != '0000') {
      throw Exception(data['sysMessage'] ?? 'AI 代理调用失败');
    }

    final result = data['data'] as Map<String, dynamic>;
    final text = result['content'] as String? ?? '';

    debugPrint('╔══ 🤖 [AI代理回复] ══');
    debugPrint('║  $text');
    debugPrint('╚══');

    return text;
  }
}
