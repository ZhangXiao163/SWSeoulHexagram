class LoginManager {
  // 单例
  LoginManager._internal();

  static final LoginManager instance = LoginManager._internal();
  late String loginName;
  bool isLogin = false;

  void login(String name) {
    loginName = name;
    isLogin = true;
  }

  String getLoginName() {
    return loginName;
  }
}
