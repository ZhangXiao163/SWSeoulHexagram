import 'package:ai_food/config/login_manager.dart';
import 'package:flutter/material.dart';

import 'config/StrConfig.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 登录校验
  void _onLoginPressed() {
    final account = accountController.text.trim();
    final password = passwordController.text.trim();

    if (account.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StrConfig.of(context).loginToss),
          backgroundColor: const Color(0xFF6D5AE6),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    LoginManager.instance.login(account);
    debugPrint("点击登录");
    Navigator.pop(context);
    // 继续后续登录逻辑
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1FF),
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),

            child: Column(
              children: [
                const SizedBox(height: 30),

                // Tiger头像
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/tiger.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  StrConfig.of(context).lgWelcome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D5AE6),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  StrConfig.of(context).lgWelAi,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 40),

                // 账号输入框
                _buildInputBox(
                  hint: StrConfig.of(context).pleaseAcc,
                  icon: Icons.account_box,
                  controller: accountController,
                ),

                const SizedBox(height: 18),

                // 密码输入框
                _buildInputBox(
                  hint: StrConfig.of(context).pleasePwd,
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                // 登录按钮
                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed: _onLoginPressed,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D5AE6),
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: Text(
                      StrConfig.of(context).login,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 分割线
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // 第三方登录（预留位置）
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(width: 20), SizedBox(width: 20)],
                ),

                const SizedBox(height: 40),

                // 注册
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StrConfig.of(context).noAcc,
                      style: const TextStyle(color: Colors.grey),
                    ),

                    TextButton(
                      onPressed: () {},

                      child: Text(
                        StrConfig.of(context).registerSoon,
                        style: const TextStyle(
                          color: Color(0xFF6D5AE6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 输入框
  Widget _buildInputBox({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Container(
      height: 56,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(
        controller: controller,
        obscureText: obscureText,

        decoration: InputDecoration(
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          prefixIcon: Icon(icon, color: const Color(0xFF6D5AE6)),

          hintText: hint,

          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  // 第三方登录按钮（备用）
  Widget _buildSocialButton({required IconData icon, required Color color}) {
    return Container(
      width: 52,
      height: 52,

      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Icon(icon, color: color, size: 28),
    );
  }
}
