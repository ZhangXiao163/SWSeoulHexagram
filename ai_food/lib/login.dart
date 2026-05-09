import 'package:flutter/material.dart';

import 'config/StrConfig.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1FF),

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
                  StrConfig
                      .of(context)
                      .lgWelcome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6D5AE6),
                  ),
                ),

                const SizedBox(height: 10),

                 Text(
                  StrConfig
                      .of(context)
                      .lgWelAi,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // 手机号
                _buildInputBox(
                  hint:    StrConfig
                      .of(context)
                      .pleaseAcc,
                  icon: Icons.account_box,
                ),

                const SizedBox(height: 18),

                // 密码
                _buildInputBox(
                  hint:    StrConfig
                      .of(context)
                      .pleasePwd,
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // 忘记密码
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {},
                //     child: const Text(
                //       "忘记密码？",
                //       style: TextStyle(
                //         color: Color(0xFF6D5AE6),
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 15),

                // 登录按钮
                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint("点击登录");
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D5AE6),
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child:  Text(
                      StrConfig
                          .of(context)
                          .login,
                      style: TextStyle(
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

                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 12),
                    //   child: Text(
                    //     "其他登录方式",
                    //     style: TextStyle(
                    //       color: Colors.grey,
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),

                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // 第三方登录
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // _buildSocialButton(
                    //   icon: Icons.wechat,
                    //   color: Colors.green,
                    // ),

                    const SizedBox(width: 20),

                    // _buildSocialButton(
                    //   icon: Icons.email,
                    //   color: Colors.orange,
                    // ),

                    const SizedBox(width: 20),

                    // _buildSocialButton(
                    //   icon: Icons.g_mobiledata,
                    //   color: Colors.red,
                    // ),
                  ],
                ),

                const SizedBox(height: 40),

                // 注册
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                     Text(
                      StrConfig
                          .of(context)
                          .noAcc,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    TextButton(
                      onPressed: () {},

                      child:  Text(
                        StrConfig
                            .of(context)
                            .registerSoon,
                        style: TextStyle(
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
        obscureText: obscureText,

        decoration: InputDecoration(
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          prefixIcon: Icon(
            icon,
            color: const Color(0xFF6D5AE6),
          ),

          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // 第三方登录按钮
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
  }) {
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

      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }
}