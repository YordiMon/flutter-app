class Comment {
  final int id;
  final String comment;
  final String user;

  Comment({
    required this.id,
    required this.comment,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      comment: json['comment'],
      user: json['user_name'],
    );
  }
}
