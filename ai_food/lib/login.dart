import 'package:ai_food/config/login_manager.dart';
import 'package:ai_food/service/api_service.dart';
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
  bool _logging = false;
  bool _isRegisterMode = false;

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 登录/注册
  Future<void> _onSubmit() async {
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

    setState(() => _logging = true);

    try {
      if (_isRegisterMode) {
        // 注册
        await ApiService().register(account, password);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StrConfig.of(context).registerSuccess), backgroundColor: Colors.green),
        );
        setState(() => _isRegisterMode = false);
        setState(() => _logging = false);
        return;
      }

      // 登录
      final res = await ApiService().login(account, password);
      if (!mounted) return;
      print(res.toString());
      final code = res['sysCode'] as String?;
      if (code == '0000') {
        LoginManager.instance.login(account);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(StrConfig.of(context).loginSuccess), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        }
      } else {
        final msg = res['sysMessage'] as String? ?? StrConfig.of(context).loginFail;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${StrConfig.of(context).networkErrorPrefix} $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _logging = false);
    }
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
                  _isRegisterMode ? StrConfig.of(context).registerAccount : StrConfig.of(context).lgWelcome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D5AE6),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isRegisterMode ? StrConfig.of(context).registerHint : StrConfig.of(context).lgWelAi,
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
                    onPressed: _logging ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D5AE6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _logging
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isRegisterMode ? StrConfig.of(context).registerBtnText : StrConfig.of(context).login,
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
                      child: Container(height: 1, color: Colors.grey.withOpacity(0.2)),
                    ),
                    Expanded(
                      child: Container(height: 1, color: Colors.grey.withOpacity(0.2)),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // 切换登录/注册模式
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isRegisterMode ? StrConfig.of(context).hasAccountText : StrConfig.of(context).noAcc,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _isRegisterMode = !_isRegisterMode);
                      },
                      child: Text(
                        _isRegisterMode ? StrConfig.of(context).goLoginText : StrConfig.of(context).registerSoon,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          prefixIcon: Icon(icon, color: const Color(0xFF6D5AE6)),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
