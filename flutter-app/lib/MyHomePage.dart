import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/History.dart';
import 'package:project/HistoryPage.dart';

Future<List<History>> fetchHistories() async {
  final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/histories'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => History.fromJson(item as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Fallo al cargar las historias');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<History>> futureHistories;

  @override
  void initState() {
    super.initState();
    futureHistories = fetchHistories();
  }

  @override
  Widget build(BuildContext context) {
    final double currentWidth = MediaQuery.of(context).size.width;
    final double currentHeight = MediaQuery.of(context).size.height;

    // ignore: deprecated_member_use
    return  WillPopScope(
    onWillPop: () async {
      exit(0);
    },child: Scaffold(
        body: Center(
          child: FutureBuilder<List<History>>(
            future: futureHistories,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.map((history) =>
                    Container(
                      margin: const EdgeInsets.only(top: 4, right: 20, left: 20, bottom: 4),
                      padding: const EdgeInsets.only(right: 20),
                      height: currentHeight * 0.225,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                      ),

                        child: Ink(

                          child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => HistoryPage(id: history.id)
                              ),
                            );
                          },

                        child:  
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(0), 
                                bottomLeft: Radius.circular(20),  
                                bottomRight: Radius.circular(0), 
                              ),
                              child: Image.asset(
                                'assets/logo.png',
                              ),
                            ),

                            const SizedBox(width: 12,),

                            Expanded(
                              
                              child: 
                              Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const SizedBox(width: 10,),

                                Text(
                                  history.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: currentWidth * 0.04,
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                Text(
                                  history.synopsis,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: currentWidth * 0.03,
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                Text(
                                  'Género: ${history.genre}',

                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: currentWidth * 0.0225,
                                  ),
                                ),

                                const SizedBox(height: 2,),

                                Text(
                                  'Autor: ${history.user}',

                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: currentWidth * 0.0225,
                                  ),
                                ),

                              ]
                            ),
                            ),
                          ]

                      )
                    )
                        ),
                        
                  )).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        )
    ));
  }
}