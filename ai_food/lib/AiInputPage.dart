import 'package:flutter/material.dart';
import 'AiResultPage.dart';
import 'ai_service.dart';
class AiInputPage extends StatefulWidget {
  const AiInputPage({super.key});

  @override
  _AiInputPageState createState() => _AiInputPageState();
}

class _AiInputPageState extends State<AiInputPage> {
  final TextEditingController _controller = TextEditingController();

  // void _submitInput() {
  //   String userInput = _controller.text.trim();
  //
  //   if (userInput.isEmpty) return;
  //
  //   // 👉 这里之后可以接AI接口
  //   print("用户输入: $userInput");
  //
  //   // 跳转到结果页（你后面做）
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => AiResultPage(input: userInput),
  //     ),
  //   );
  // }


  bool isLoading = false;

  void _submitInput() async {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    String result = await AiService.getRecommendation(userInput);

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiResultPage(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI 추천"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 标题
            Text(
              "원하는 음식을 입력하세요",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),
            // ✅ 👇 放这里（推荐）
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),

            // 提示
            Text(
              "예: 매운 음식, 1만 원 이하, 혼밥",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20),

            // 输入框
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "예: 매운 음식이 먹고 싶어요",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 20),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitInput,
                child: Text("추천 받기"),
              ),
            ),

            SizedBox(height: 20),

            // 示例按钮（加分点）
            Wrap(
              spacing: 10,
              children: [
                _exampleChip("매운 음식"),
                _exampleChip("다이어트 음식"),
                _exampleChip("가성비 좋은 음식"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exampleChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _controller.text = text;
      },
    );
  }
}


// 👉 简单结果页（先占位用）
// class AiResultPage extends StatelessWidget {
//   final String result;
//
//   const AiResultPage({required this.result});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("추천 결과")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           result,
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }