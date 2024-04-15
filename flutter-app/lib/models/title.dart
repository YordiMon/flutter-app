class Title{
  final int id;
  final String title;

  const Title({
    required this.id,
    required this.title,
  });

  factory Title.fromJson(Map<String,dynamic>json) {
    return switch(json) {
      {
        'id': int id,
        'title': String title,
      } =>
      Title(
        id:id,
        title:title,
      ), 
    _=>throw const FormatException('Falló al cargar modelo.'),
    };
  }
}