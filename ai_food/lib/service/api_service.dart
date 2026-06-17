import 'dart:convert';
import 'dart:io' show HttpOverrides, HttpClient, X509Certificate, SecurityContext;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ai_food/ai/secrets.dart';

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

  // 后端地址（通过 Nginx /api/ 路径代理）
  static final String _baseUrl = Secrets.apiBaseUrl.isEmpty
      ? 'http://15.165.195.197/api'
      : Secrets.apiBaseUrl;

  /// 对外暴露 baseUrl（供 AiService 等模块使用）
  String get baseUrl => _baseUrl;

  // 当前语言（后端根据此字段返回对应语言的内容）
  String _lang = 'cn';
  String get lang => _lang;
  set lang(String v) {
    _lang = v;
    _allFoodsCache = null; // 清除缓存，下次重新获取
  }

  /// 从 appLocale 同步语言
  void syncLocale(Locale locale) {
    lang = locale.languageCode == 'ko' ? 'ko' : 'cn';
  }

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
    final res = await _get('/swMerchant/list', {'merchantClass': '$merchantClass', 'lang': _lang});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 按名称搜索商家
  Future<List<dynamic>> searchMerchant(String name) async {
    final res = await _get('/swMerchant/merchantName', {'merchantName': name, 'lang': _lang});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 按商家ID查食品
  Future<List<dynamic>> getFoodByMerchantId(int merchantId) async {
    final res = await _get('/swFood/findFoodByMerchantId/$merchantId', {'lang': _lang});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 按食品ID查详情
  Future<Map<String, dynamic>> getFoodById(int foodId) async {
    final res = await _get('/swFood/findFoodByFoodId/$foodId', {'lang': _lang});
    return res['data'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> addCart({
    required int userId,
    required int foodId,
    required int merchantId,
    required int foodNum,
    required double foodPrice,
    required String foodName,
  }) async {
    return _post('/swCart/addCart', {
      'userId': userId,
      'foodId': foodId,
      'merchantId': merchantId,
      'foodNum': foodNum,
      'foodPrice': foodPrice,
      'foodName': foodName,
    });
  }
  Future<List<dynamic>> getCartList() async {
    final res = await _get('/swCart/findByUserId/1', {});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 删除购物车商品
  Future<void> deleteCart(int cartId) async {
    await _get('/swCart/delete/$cartId', {});
  }

  /// 提交订单
  Future<Map<String, dynamic>> submitOrder({
    required String orderNo,
    required int userId,
    required int merchantId,
    int addressId = 0,
    required double totalPrice,
    int orderStatus = 0,
  }) async {
    return _post('/swOrder/save/', {
      'orderNo': orderNo,
      'userId': userId,
      'merchantId': merchantId,
      'addressId': addressId,
      'totalPrice': totalPrice,
      'orderStatus': orderStatus,
    });
  }

  /// 获取所有在售菜品（聚合所有商家的菜单，用于 AI 推荐）
  /// 返回 [{foodId, foodName, price, merchantId, merchantName}, ...]
  List<Map<String, dynamic>>? _allFoodsCache;

  Future<List<Map<String, dynamic>>> getAllFoods() async {
    // 有缓存直接返回
    if (_allFoodsCache != null && _allFoodsCache!.isNotEmpty) {
      debugPrint('🔍 [getAllFoods] 命中缓存，${_allFoodsCache!.length} 道菜');
      return _allFoodsCache!;
    }

    debugPrint('🔍 [getAllFoods] 开始遍历 4 个分类...');
    final allFoods = <Map<String, dynamic>>[];

    for (int merchantClass = 0; merchantClass < 4; merchantClass++) {
      try {
        final merchants = await _get('/swMerchant/list', {'merchantClass': '$merchantClass', 'lang': _lang});
        final merchantList = merchants['data'] as List<dynamic>? ?? [];
        debugPrint('🔍 [getAllFoods] 分类$merchantClass: ${merchantList.length} 个商家');
        if (merchantList.isNotEmpty) {
          debugPrint('🔍 [getAllFoods] 第一个商家原始字段: ${merchantList.first.runtimeType}');
        }

        for (final m in merchantList) {
          // 兼容多种 ID 字段名
          final merchantId = (m['id'] as num?)?.toInt() ??
                             (m['merchantId'] as num?)?.toInt() ?? 0;
          final merchantName = (m['merchantName'] as String?) ??
                               (m['name'] as String?) ?? '';
          if (merchantId == 0) {
            debugPrint('  ⚠️ 商家 ID 为 0，跳过: $m');
            continue;
          }

          try {
            final foodResp = await _get('/swFood/findFoodByMerchantId/$merchantId', {'lang': _lang});
            final foodList = foodResp['data'] as List<dynamic>? ?? [];
            debugPrint('  📋 商家 $merchantId ($merchantName): ${foodList.length} 道菜');
            for (final f in foodList) {
              allFoods.add({
                'foodId': (f['foodId'] as num?)?.toInt() ?? 0,
                'foodName': f['foodName'] as String? ?? '',
                'price': (f['price'] as num?)?.toDouble() ?? 0.0,
                'merchantId': merchantId,
                'merchantName': merchantName,
              });
            }
          } catch (e) {
            debugPrint('  ❌ 获取商家 $merchantId 菜品失败: $e');
          }
        }
      } catch (e) {
        debugPrint('❌ [getAllFoods] 分类 $merchantClass 失败: $e');
      }
    }

    debugPrint('🔍 [getAllFoods] 完成: 共 ${allFoods.length} 道菜');
    _allFoodsCache = allFoods;
    return allFoods;
  }

  /// 清除菜品缓存（语言切换后可调用）
  void clearFoodsCache() {
    _allFoodsCache = null;
  }

  /// 查询用户订单列表
  Future<List<dynamic>> findOrdersByUserId(int userId) async {
    final res = await _get('/swOrder/findByUserId/$userId', {});
    return res['data'] as List<dynamic>? ?? [];
  }

  /// 查询评价（带语言参数）
  Future<List<dynamic>> queryCommentsByFoodIdAndMerchantId(int foodId, int merchantId) async {
    final res = await _get('/swComments/queryCommentsByFoodIdAndMerchantId/$foodId/$merchantId', {'lang': _lang});
    return res['data'] as List<dynamic>? ?? [];
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
