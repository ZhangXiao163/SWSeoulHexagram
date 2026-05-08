import 'dart:convert';
import 'package:ai_food/ai/secrets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = Secrets.geminiApiKey; // 记得替换
  late final GenerativeModel model;

  GeminiService() {
    model = GenerativeModel(
      model: 'gemini-3-flash-preview', // 尝试用这个最基础的名字
      apiKey: apiKey,
      // 设置系统指令，强制它只返回 JSON 格式
      systemInstruction: Content.system("你是一个外卖平台数据分析师。请返回5条当下的美食趋势。必须以 JSON 数组格式返回，包含字段：title, sub, value。不要包含任何 Markdown 格式。"),
    );
  }

  Future<List<Map<String, dynamic>>> getTrends(String query) async {
    final prompt = "根据搜索词 '$query'，生成相关的热门外卖趋势。";
    final content = [Content.text(prompt)];

    try {
      final response = await model.generateContent(content);
      // 解析 JSON
      final List<dynamic> data = jsonDecode(response.text!);
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print("Gemini Error: $e");
      return [];
    }
  }
}