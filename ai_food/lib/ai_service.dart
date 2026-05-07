import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // static const String key ="";
  // static Future<String> getRecommendation(String userInput) async {
  //   final url = Uri.parse("https://api.openai.com/v1/chat/completions");
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $key",
  //     },
  //     body: jsonEncode({
  //       "model": "gpt-4o-mini",
  //       "messages": [
  //         {
  //           "role": "system",
  //           "content": "你是一个外卖推荐助手，请根据用户需求推荐一道菜，并给出理由（简短）"
  //         },
  //         {
  //           "role": "user",
  //           "content": userInput
  //         }
  //       ],
  //       "max_tokens": 100
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data["choices"][0]["message"]["content"];
  //   } else {
  //     print("请求失败: ${response.body}");
  //     return "추천 실패";
  //   }
  // }
  static Future<String> getRecommendation(String userInput) async {
    await Future.delayed(Duration(seconds: 1)); // 模拟请求

    switch (userInput) {
      case "매운 한식":
        return "추천: 떡볶이\n이유: 매운 음식을 원하셨고, 가격도 적당합니다.\n11000";
        break;
      case "다이어트 음식":
        return "추천: 비빔밥\n이유: 다이어트 음식을 원하셨습니다.\n9000";
        break;
      case "가성비 좋은 음식":
        return "추천: 라면\n이유: 가성비 좋은 음식을 원하셨습니다.\n7500";
        break;
    }
    // return "추천: 라면\n이유: 가성비 좋은 음식을 원하셨습니다.";
    //return "추천: 비빔밥\n이유: 다이어트 음식을 원하셨습니다.";
    return "추천: 떡볶이\n이유: 매운 음식을 원하셨고, 가격도 적당합니다.\n11000";
  }
}
