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

      'dessert_food': '甜品',
      'thai_food': '甜品',
      'takeout': '外卖',
      'mine': '我的',
      'order': '订单',
      'car': '购物车',
      'my_order': '我的订单',
      'input_name': '请输入商户名称',
      'pro_not_found': '未找到',
      'login_overtime': '登录已过期，请重新登录...',
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

      'buy_again': '再次购买',
      'retry': '重试',
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
      'detail_tag': '月售500+, 招牌',

      // 购物车页
      'cart_title': '购物车',
      'select_all': '全选',
      'total_label': '合计:',
      'checkout': '去结算',
      'self_operated': '自营',
      'cart_empty': '购物车是空的',
      'load_failed_msg': '加载失败，请重试',
      'tips': '提示',
      'confirm_delete': '确定要删除「{0}」吗？',
      'cancel': '取消',
      'confirm': '确定',
      'unknown_item': '未知商品',
      'shop_prefix': '店铺',

      // 登录/注册页
      'register_account': '注册账号',
      'register_hint': '创建账号后即可登录',
      'register_btn_text': '注册',
      'has_account_text': '已有账号？',
      'go_login_text': '去登录',
      'register_success': '注册成功，请登录',
      'login_success': '登录成功',
      'login_fail': '登录失败',
      'network_error_prefix': '网络错误:',

      // 订单完成页
      'order_complete_title': '订单完成',
      'order_completed': '订单已完成',
      'order_thanks': '感谢您的购买\n祝您用餐愉快 ㅎㅎ',
      'order_number_label': '订单编号',
      'payment_amount_label': '支付金额',
      'back_to_home': '返回主页',
      'order_again': '再来一单',

      // 订单确认页
      'confirm_order': '确认订单',
      'discount_saved': '已优惠 ¥{0}',
      'total_price_summary': '合计 ¥{0}',
      'submit_order': '提交订单',
      'warm_tips_text': '温馨提示：请注意查看配送时间',
      'delivery_address': '配送地址',
      'delivery_time': '送达时间',
      'payment_method': '支付方式',
      'packaging_fee': '包装费',
      'delivery_fee_label': '配送费',
      'coupon_discount': '红包优惠',
      'estimated_delivery': '大约{0}送达',

      // 详情页
      'add_cart_success': '加购物车成功',
      'add_cart_fail': '加购物车失败',
      'add_cart_error': '加购物车失败: {0}',

      // 菜单页
      'menu': '菜单',
      'load_fail_prefix': '加载失败: {0}',
      'search_menu': '搜索菜单',
      'popular': '人气',
      'recommended': '推荐',

      // 订单列表
      'no_orders': '暂无订单',
      'total_items': '共{0}件',

      // 首页
      'no_nearby': '附近暂无商家',

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

      // 'thai_food': '태국 요리',
      'dessert_food': '디저트',

      'thai_food': '디저트',

      'takeout': '배달',
      'mine': '마이페이지',
      'order': '주문내역',
      'car': '쇼핑 카트',
      // 顶部标题栏
      'ai_helper_title': 'AI 푸드 헬퍼',
      'ai_helper_subtitle': '먹고 싶은 메뉴를 알려주세요 ✨',
      'input_name': '판매자 이름을 입력해 주세요.',
      'pro_not_found': '찾을 수 없음',
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
      'my_order': '나의 주문서',

      'buy_again': '재구매',
      'login_overtime': '로그인 시간이 만료되었습니다. 다시 로그인해 주세요...',
       'retry': '재시도',
      'detail_tag': '월간 판매량 500건 이상, 시그니처',

      // 장바구니
      'cart_title': '장바구니',
      'select_all': '전체 선택',
      'total_label': '합계:',
      'checkout': '주문하기',
      'self_operated': '직영',
      'cart_empty': '장바구니가 비어 있습니다',
      'load_failed_msg': '로딩 실패, 다시 시도해주세요',
      'tips': '알림',
      'confirm_delete': '「{0}」을(를) 삭제하시겠습니까?',
      'cancel': '취소',
      'confirm': '확인',
      'unknown_item': '알 수 없는 상품',
      'shop_prefix': '가게',

      // 로그인/회원가입
      'register_account': '회원가입',
      'register_hint': '계정을 만들면 로그인할 수 있습니다',
      'register_btn_text': '회원가입',
      'has_account_text': '이미 계정이 있나요?',
      'go_login_text': '로그인하기',
      'register_success': '회원가입 성공, 로그인해주세요',
      'login_success': '로그인 성공',
      'login_fail': '로그인 실패',
      'network_error_prefix': '네트워크 오류:',

      // 주문 완료
      'order_complete_title': '주문 완료',
      'order_completed': '주문이 완료되었습니다',
      'order_thanks': '구매해 주셔서 감사합니다\n맛있게 드세요 ㅎㅎ',
      'order_number_label': '주문 번호',
      'payment_amount_label': '결제 금액',
      'back_to_home': '홈으로 돌아가기',
      'order_again': '다시 주문하기',

      // 주문 확인
      'confirm_order': '주문 확인',
      'discount_saved': '할인 ¥{0}',
      'total_price_summary': '합계 ¥{0}',
      'submit_order': '주문 제출',
      'warm_tips_text': '안내: 배송 시간을 확인해주세요',
      'delivery_address': '배송 주소',
      'delivery_time': '배송 시간',
      'payment_method': '결제 수단',
      'packaging_fee': '포장비',
      'delivery_fee_label': '배송비',
      'coupon_discount': '쿠폰 할인',
      'estimated_delivery': '약 {0} 도착 예정',

      // 상세 페이지
      'add_cart_success': '장바구니 담기 성공',
      'add_cart_fail': '장바구니 담기 실패',
      'add_cart_error': '장바구니 담기 실패: {0}',

      // 메뉴 페이지
      'menu': '메뉴',
      'load_fail_prefix': '로딩 실패: {0}',
      'search_menu': '메뉴 검색',
      'popular': '인기',
      'recommended': '추천',

      // 주문 목록
      'no_orders': '주문 내역이 없습니다',
      'total_items': '총 {0}개',

      // 홈
      'no_nearby': '주변에 가게가 없습니다',
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

  /// 返回分类名称列表（4个）
  List<String> get categoryLabels => [chineseFood, krFood, westernFood, thaiFood];

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
  String get buyCar => _data[locale.languageCode]!['car']!;
  String get myOrder => _data[locale.languageCode]!['my_order']!;
  String get buyAgain => _data[locale.languageCode]!['buy_again']!;
  String get dessertFood => _data[locale.languageCode]!['dessert_food']!;
  String get inputName => _data[locale.languageCode]!['input_name']!;
  String get proNotFound => _data[locale.languageCode]!['pro_not_found']!;
  String get loginOverTime => _data[locale.languageCode]!['login_overtime']!;
  String get retry => _data[locale.languageCode]!['retry']!;
  String get detailTag => _data[locale.languageCode]!['detail_tag']!;

  // 购物车
  String get cartTitle => _data[locale.languageCode]!['cart_title']!;
  String get selectAll => _data[locale.languageCode]!['select_all']!;
  String get totalLabel => _data[locale.languageCode]!['total_label']!;
  String get checkout => _data[locale.languageCode]!['checkout']!;
  String get selfOperated => _data[locale.languageCode]!['self_operated']!;
  String get cartEmpty => _data[locale.languageCode]!['cart_empty']!;
  String get loadFailedMsg => _data[locale.languageCode]!['load_failed_msg']!;
  String get tips => _data[locale.languageCode]!['tips']!;
  String get confirmDelete => _data[locale.languageCode]!['confirm_delete']!;
  String get cancel => _data[locale.languageCode]!['cancel']!;
  String get confirm => _data[locale.languageCode]!['confirm']!;
  String get unknownItem => _data[locale.languageCode]!['unknown_item']!;
  String get shopPrefix => _data[locale.languageCode]!['shop_prefix']!;

  // 登录/注册
  String get registerAccount => _data[locale.languageCode]!['register_account']!;
  String get registerHint => _data[locale.languageCode]!['register_hint']!;
  String get registerBtnText => _data[locale.languageCode]!['register_btn_text']!;
  String get hasAccountText => _data[locale.languageCode]!['has_account_text']!;
  String get goLoginText => _data[locale.languageCode]!['go_login_text']!;
  String get registerSuccess => _data[locale.languageCode]!['register_success']!;
  String get loginSuccess => _data[locale.languageCode]!['login_success']!;
  String get loginFail => _data[locale.languageCode]!['login_fail']!;
  String get networkErrorPrefix => _data[locale.languageCode]!['network_error_prefix']!;

  // 订单完成
  String get orderCompleteTitle => _data[locale.languageCode]!['order_complete_title']!;
  String get orderCompleted => _data[locale.languageCode]!['order_completed']!;
  String get orderThanks => _data[locale.languageCode]!['order_thanks']!;
  String get orderNumberLabel => _data[locale.languageCode]!['order_number_label']!;
  String get paymentAmountLabel => _data[locale.languageCode]!['payment_amount_label']!;
  String get backToHome => _data[locale.languageCode]!['back_to_home']!;
  String get orderAgain => _data[locale.languageCode]!['order_again']!;

  // 订单确认
  String get confirmOrder => _data[locale.languageCode]!['confirm_order']!;
  String get discountSaved => _data[locale.languageCode]!['discount_saved']!;
  String get totalPriceSummary => _data[locale.languageCode]!['total_price_summary']!;
  String get submitOrder => _data[locale.languageCode]!['submit_order']!;
  String get warmTipsText => _data[locale.languageCode]!['warm_tips_text']!;
  String get deliveryAddress => _data[locale.languageCode]!['delivery_address']!;
  String get deliveryTime => _data[locale.languageCode]!['delivery_time']!;
  String get paymentMethod => _data[locale.languageCode]!['payment_method']!;
  String get packagingFee => _data[locale.languageCode]!['packaging_fee']!;
  String get deliveryFeeLabel => _data[locale.languageCode]!['delivery_fee_label']!;
  String get couponDiscount => _data[locale.languageCode]!['coupon_discount']!;
  String get estimatedDelivery => _data[locale.languageCode]!['estimated_delivery']!;

  // 详情页
  String get addCartSuccess => _data[locale.languageCode]!['add_cart_success']!;
  String get addCartFail => _data[locale.languageCode]!['add_cart_fail']!;
  String get addCartError => _data[locale.languageCode]!['add_cart_error']!;

  // 菜单页
  String get menu => _data[locale.languageCode]!['menu']!;
  String get loadFailPrefix => _data[locale.languageCode]!['load_fail_prefix']!;
  String get searchMenu => _data[locale.languageCode]!['search_menu']!;
  String get popular => _data[locale.languageCode]!['popular']!;
  String get recommended => _data[locale.languageCode]!['recommended']!;

  // 订单列表
  String get noOrders => _data[locale.languageCode]!['no_orders']!;
  String get totalItems => _data[locale.languageCode]!['total_items']!;

  // 首页
  String get noNearby => _data[locale.languageCode]!['no_nearby']!;

  static StrConfig of(BuildContext context) {
    return StrConfig(Localizations.localeOf(context));
  }
}