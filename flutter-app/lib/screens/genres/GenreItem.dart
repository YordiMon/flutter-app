import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/CustomAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/Genre.dart';

Future<Genre>fetchGenre() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/genres/1'));

  if (response.statusCode == 200) {
    return Genre.fromJson(jsonDecode(response.body)
    as Map<String, dynamic>);
  } else {
    throw Exception('Fallo al cargar la historia');
  }
}

class GenreItem extends StatefulWidget {
  const GenreItem({super.key, required this.title});

  final String title;

  @override
  State<GenreItem> createState() => _GenreItemState();
}

class _GenreItemState extends State<GenreItem> {
  late Future<Genre> futureGenre;

  @override
  void initState() {
    super.initState();
    futureGenre = fetchGenre();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Obtener datos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade100),
      ),
      home: Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: FutureBuilder<Genre>(
            future: futureGenre,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.genre),
                    Text(snapshot.data!.id.toString()),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            })
          )
        ),
      );
  }
}