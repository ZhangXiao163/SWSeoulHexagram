class TrendItem {  // 确保这里叫 TrendItem
  final int rank;
  final String name;
  final String trend;
  final String reason;
  final String search;
  TrendItem({required this.rank, required this.name, required this.trend, required this.reason,required this.search});

  factory TrendItem.fromJson(Map<String, dynamic> json) {
    return TrendItem(
      rank: json['rank'] ?? 0,
      name: json['name'] ?? '',
      trend: json['trend'] ?? '',
      reason: json['reason'] ?? '',
      search: json['search'] ?? '',
    );
  }
}