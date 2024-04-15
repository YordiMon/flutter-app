import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/CustomAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/Genre.dart';

Future<List<Genre>> fetchGenres() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/genres'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Genre.fromJson(item as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Fallo al cargar los géneros');
  }
}

class GenreList extends StatefulWidget {
  const GenreList({super.key, required this.title});

  final String title;

  @override
  State<GenreList> createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  late Future<List<Genre>> futureGenres;

  @override
  void initState() {
    super.initState();
    futureGenres = fetchGenres();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Obtener lista de datos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade100),
      ),
      home: Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: FutureBuilder<List<Genre>>(
            future: futureGenres,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.map((genre) => Column(
                    children: <Widget>[
                      const SizedBox(height: 15,),
                      Text(genre.id.toString()),
                      Text(genre.genre),
                      const SizedBox(height: 15,),
                    ],
                  )).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        )
      ),
    );
  }
}