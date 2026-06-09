import 'dart:convert';
import 'dart:io' show HttpOverrides, HttpClient, X509Certificate, SecurityContext;
import 'package:http/http.dart' as http;

/// 后端 API 服务 — 所有和后端的交互统一走这里
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    // 非 Web 平台允许自签名证书（开发阶段）
    try {
      HttpOverrides.global = _MyHttpOverrides();
    } catch (_) {}
  }

  // 后端地址（用 HTTP 避免自签名证书问题）
  static const String _baseUrl = 'http://15.165.195.197:8080';

  // 登录后保存 token（去掉 LOGIN_TOKEN: 前缀后的 UUID 部分）
  String? _token;
  String? get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  /// 注册
  Future<Map<String, dynamic>> register(String userName, String password) async {
    return _post('/swUser/register', {
      'userName': userName,
      'password': password,
    });
  }

  /// 登录，自动保存 token
  Future<Map<String, dynamic>> login(String userName, String password) async {
    final res = await _post('/swUser/login', {
      'userName': userName,
      'password': password,
    });
    final rawData = res['data'] as String? ?? '';
    _token = rawData.replaceFirst('LOGIN_TOKEN:', '');
    return res;
  }

  /// 登出
  Future<void> logout() async {
    if (_token == null) return;
    await _post('/swUser/logout', {});
    _token = null;
  }

  /// 获取商家列表
  Future<List<dynamic>> getMerchantList(int merchantClass) async {
    final res = await _get('/swMerchant/list', {'merchantClass': '$merchantClass'});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 按名称搜索商家
  Future<List<dynamic>> searchMerchant(String name) async {
    final res = await _get('/swMerchant/merchantName', {'merchantName': name});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 按商家ID查食品
  Future<List<dynamic>> getFoodByMerchantId(int merchantId) async {
    final res = await _get('/swFood/findFoodByMerchantId/$merchantId', {});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 按食品ID查详情
  Future<Map<String, dynamic>> getFoodById(int foodId) async {
    final res = await _get('/swFood/findFoodByFoodId/$foodId', {});
    return res['data'] as Map<String, dynamic>? ?? {};
  }

  // ── 通用 GET ──
  Future<Map<String, dynamic>> _get(String path, Map<String, String> params) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: params.isNotEmpty ? params : null);
    return _request(uri, 'GET');
  }

  // ── 通用 POST ──
  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$path');
    return _request(uri, 'POST', body: body);
  }

  // ── 核心请求 ──
  Future<Map<String, dynamic>> _request(Uri uri, String method, {Map<String, dynamic>? body}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = _token!;
    }

    late http.Response res;

    if (method == 'GET') {
      res = await http.get(uri, headers: headers);
    } else {
      res = await http.post(uri, headers: headers, body: body != null ? jsonEncode(body) : null);
    }

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
  }
}

/// 全局允许自签名证书（仅非 Web 平台生效）
class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
