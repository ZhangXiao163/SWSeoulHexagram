import 'package:ai_food/ai/secrets.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal() {
    // model = GenerativeModel(
    //   model: 'gemini-2.5-flash-lite',
    //   apiKey: apiKey,
    // );
    geminiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=${Secrets.geminiApiKey}';
  }

  final String apiKey = Secrets.geminiApiKey;

  // late final GenerativeModel model;
  late final String geminiUrl;

  String getGeminiUrl() {
    return geminiUrl;
  }
}
