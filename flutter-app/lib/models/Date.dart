class Date{
  final int id;
  final String date;

  const Date({
    required this.id,
    required this.date,
  });

  factory Date.fromJson(Map<String,dynamic>json) {
    return switch(json) {
      {
        'id': int id,
        'date': String date,
      } =>
      Date(
        id:id,
        date:date,
      ), 
    _=>throw const FormatException('Falló al cargar modelo.'),
    };
  }
}