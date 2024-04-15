class Like {
  final int id;
  final int historyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Like({
    required this.id,
    required this.historyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      historyId: json['history_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
