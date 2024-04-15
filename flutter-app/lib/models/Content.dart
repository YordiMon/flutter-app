class Content{
  final int id;
  final String content;

  const Content({
    required this.id,
    required this.content,
  });

  factory Content.fromJson(Map<String,dynamic>json) {
    return switch(json) {
      {
        'id': int id,
        'content': String content,
      } =>
      Content(
        id:id,
        content:content,
      ), 
    _=>throw const FormatException('Falló al cargar modelo.'),
    };
  }
}