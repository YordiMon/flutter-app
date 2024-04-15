class History {
  final int id;
  final String title;
  final String synopsis;
  final String content;
  final String genre;
  final String date;
  final String user;
  final DateTime created;
  final DateTime updated;

  History({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.content,
    required this.genre,
    required this.date,
    required this.user,
    required this.created,
    required this.updated,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      title: json['title'],
      synopsis: json['synopsis'],
      content: json['content'],
      genre: json['genre'],
      date: json['date_'],
      user: json['user'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }
}