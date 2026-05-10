import 'package:flutter/material.dart';

class StrConfig {
  final Locale locale;
  StrConfig(this.locale);

  static final Map<String, Map<String, String>> _data = {
    'zh': {
      'search_hint': '搜索食物...',
      'ask_gemini': '问问 Gemini',
      'search_btn': '搜索',
      'nearby': '附近商家',
      'chinese_food': '中餐',
      'western_food': '西餐',
      'kr_food': '韩餐',
      'vit_food': '越南菜',
      'thai_food': '泰国菜',
      'takeout': '外卖',
      'mine': '我的',
      'order': '订单',



      // 顶部标题栏
      'ai_helper_title': 'AI 食物助手',
      'ai_helper_subtitle': '告诉我你想吃什么 ✨',

      // 趋势卡片
      'trending_title': '今日美食趋势',
      'trending_update': '实时更新 · 韩国最火外卖',
      'click_to_ask': '点击条目直接咨询 AI 推荐 👇',
      // 底部对话框
      'ai_greeting': '你好！我是你的 AI 美食助手 🍽️\n告诉我你今天想吃什么口味？',
      'talk_hint': '输入你的口味偏好...',
      'error': '发生了错误...',
      'current_language': '中文(Chinese)', // 添加这一行
      'login': '登录',
      //登录界面的

      'lg_welcome': '欢迎登录',
      'lg_wel_ai': '登陆后即可体验AI智能搜索',
      'please_acc': '请输入账号',
      'please_pwd': '请输入密码',
      'no_acc': '还没有账号？',
      'register_soon': '立即注册？',
      'login_toss': '账号和密码不能为空',

      //详情页
      'add_cart': '加入购物车',
      'user_review': '用户评价',
      'count': '合计',
      'ai_working': 'AI 生成评价中...',
    },
    'ko': {
      'search_hint': '음식을 검색하세요...',
      'ask_gemini': 'Gemini에게 물어보기',
      'search_btn': '검색',
      'nearby': '주변 상점',
      'chinese_food': '중식',
      'western_food': '양식',
      'kr_food': '한식',
      'vit_food': '베트남 요리',
      'thai_food': '태국 요리',
      'takeout': '배달',
      'mine': '마이페이지',
      'order': '주문내역',
      // 顶部标题栏
      'ai_helper_title': 'AI 푸드 헬퍼',
      'ai_helper_subtitle': '먹고 싶은 메뉴를 알려주세요 ✨',

      // 趋势卡片
      'trending_title': '오늘의 맛집 트렌드',
      'trending_update': '실시간 업데이트 · 한국 인기 배달 메뉴',
      'click_to_ask': '항목을 클릭하여 AI 추천을 받아보세요 👇',
      // 底部对话框
      'ai_greeting': '안녕하세요! 당신의 AI 푸드 헬퍼입니다 🍽️\n오늘 어떤 스타일의 음식을 드시고 싶으신가요?',
      'talk_hint': '입맛 취향을 입력하세요...',
      'error': '오류가 발생했습니다...',
      'current_language': '한국어(Korean)', // 添加这一行
      'login': '로그인',
      // 登录界面
      'lg_welcome': '로그인 환영합니다',
      'lg_wel_ai': '로그인 후 AI 스마트 검색을 이용할 수 있습니다',
      'please_acc': '계정을 입력하세요',
      'please_pwd': '비밀번호를 입력하세요',
      'no_acc': '아직 계정이 없으신가요?',
      'register_soon': '지금 회원가입',
      'login_toss': '계정과 비밀번호는 비워둘 수 없습니까',

      //详情页
      'add_cart': '장바구니에 담기',
      'user_review': '사용자 평가',
      'count': '도합',
      'ai_working': 'AI 생성 평가 중. ..',
    },
  };

  // 基础组件
  String get searchHint => _data[locale.languageCode]!['search_hint']!;
  String get askGemini => _data[locale.languageCode]!['ask_gemini']!;
  String get searchBtn => _data[locale.languageCode]!['search_btn']!;
  String get nearby => _data[locale.languageCode]!['nearby']!;

  // 分类标签
  String get chineseFood => _data[locale.languageCode]!['chinese_food']!;
  String get westernFood => _data[locale.languageCode]!['western_food']!;
  String get krFood => _data[locale.languageCode]!['kr_food']!;
  String get vitFood => _data[locale.languageCode]!['vit_food']!;
  String get thaiFood => _data[locale.languageCode]!['thai_food']!;

  // 底部导航
  String get takeout => _data[locale.languageCode]!['takeout']!;
  String get mine => _data[locale.languageCode]!['mine']!;
  String get order => _data[locale.languageCode]!['order']!;
  String get talkHint => _data[locale.languageCode]!['talk_hint']!;
  // --- 添加相应的 Getter ---
  String get aiHelperTitle => _data[locale.languageCode]!['ai_helper_title']!;
  String get aiHelperSubtitle => _data[locale.languageCode]!['ai_helper_subtitle']!;
  String get trendingTitle => _data[locale.languageCode]!['trending_title']!;
  String get trendingUpdate => _data[locale.languageCode]!['trending_update']!;
  String get clickToAsk => _data[locale.languageCode]!['click_to_ask']!;
  String get aiGreeting => _data[locale.languageCode]!['ai_greeting']!;

  String get errorMessage => _data[locale.languageCode]!['error']!;
  String get currentLanguageName => _data[locale.languageCode]!['current_language']!;
  String get login => _data[locale.languageCode]!['login']!;


  // 登录界面
  String get lgWelcome => _data[locale.languageCode]!['lg_welcome']!;

  String get lgWelAi => _data[locale.languageCode]!['lg_wel_ai']!;

  String get pleaseAcc => _data[locale.languageCode]!['please_acc']!;

  String get pleasePwd => _data[locale.languageCode]!['please_pwd']!;

  String get noAcc => _data[locale.languageCode]!['no_acc']!;
  String get loginToss => _data[locale.languageCode]!['login_toss']!;

  String get registerSoon => _data[locale.languageCode]!['register_soon']!;

  String get count => _data[locale.languageCode]!['count']!;
  String get addCart => _data[locale.languageCode]!['add_cart']!;
  String get userReview => _data[locale.languageCode]!['user_review']!;
  String get aiWorking => _data[locale.languageCode]!['ai_working']!;

  static StrConfig of(BuildContext context) {
    return StrConfig(Localizations.localeOf(context));
  }
}