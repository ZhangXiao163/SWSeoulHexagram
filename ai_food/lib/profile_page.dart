import 'package:flutter/material.dart';
import 'config/StrConfig.dart';
import 'config/login_manager.dart';
import 'service/api_service.dart';
import 'config/app_state.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback? onSwitchToTakeout;
  final VoidCallback? onLoginSuccess;

  const ProfilePage({super.key, this.onSwitchToTakeout, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final str = StrConfig.of(context);
    final loggedIn = LoginManager.instance.isLogin;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(str.mine, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 头像区
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6D5AE6).withValues(alpha: 0.15),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/tiger.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 40, color: Color(0xFF6D5AE6)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              loggedIn ? LoginManager.instance.getLoginName() : str.login,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // 语言切换
            _buildTile(
              context,
              icon: Icons.language,
              title: '语言 / 언어',
              trailing: Text(
                appLocale.value.languageCode == 'zh' ? '한국어' : '中文',
                style: const TextStyle(color: Color(0xFF6D5AE6), fontWeight: FontWeight.bold),
              ),
              onTap: () {
                appLocale.value = appLocale.value.languageCode == 'zh'
                    ? const Locale('ko')
                    : const Locale('zh');
                ApiService().clearFoodsCache();
              },
            ),

            // 登录 / 退出登录
            _buildTile(
              context,
              icon: loggedIn ? Icons.logout : Icons.login,
              title: loggedIn
                  ? (str.login == '登录' ? '退出登录' : '로그아웃')
                  : str.login,
              iconColor: loggedIn ? Colors.red : const Color(0xFF6D5AE6),
              onTap: () async {
                if (loggedIn) {
                  await ApiService().logout();
                  LoginManager.instance.clear();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(str.login == '登录' ? '已退出登录' : '로그아웃 되었습니다'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    onSwitchToTakeout?.call();
                  }
                } else {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                  if (result == true) {
                    onLoginSuccess?.call();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? const Color(0xFF6D5AE6)),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
