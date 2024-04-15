import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project/BranchesPage.dart';
// ignore: unused_import
import 'package:project/NavigationMenu.dart';
import 'dart:convert';
import 'package:project/models/Genre.dart';
import 'package:project/models/History.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishDraft extends StatefulWidget {
  const FinishDraft({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<FinishDraft> createState() => _FinishDraftState();
}

class _FinishDraftState extends State<FinishDraft> {
  TextEditingController titleController = TextEditingController();
  TextEditingController synopsisController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late DateTime currentDate = DateTime.now();
  late String formattedDate = '';

  late String selectedGenreName = '';
  late int selectedGenreId = -1;
  late int idUser;
  late int historyDraftId;

  late Future<History> _futureHistory;

    @override
  void initState() {
    super.initState();
    _futureHistory = fetchHistory();
    getCred();
    formattedDate = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    titleController = TextEditingController();
    synopsisController = TextEditingController();
    contentController = TextEditingController();
  }


  Future<List<Genre>> fetchGenres() async {
    final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/genres'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Genre.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Fallo al cargar los géneros');
    }
  }

  Future<History> fetchHistory() async {
  final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/history/${widget.id}'));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body); 

    return History.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Fallo al cargar la historia');
  }
}

  Future<void> createHistory(String title, String content, int genreId, String date, int userId, String synopsis) async {
  try {
    var url = Uri.parse('https://yordi.terrabyteco.com/api/chistory');
    var response = await http.post(url, body: 
      {
        "title": title.toString(),
        "content": content.toString(),
        "genre_id": genreId.toString(),
        "date": date.toString(),
        "user_id": userId.toString(),
        "synopsis": synopsis.toString()
    });

    if (response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: "Historia publicada",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const NavigationMenu()
        ),
      );
      print('Historia creada exitosamente');
    } else {
      print('Error al crear la historia: ${jsonDecode(response.body)['mensaje']}');
    }
  } catch (e) {
      Fluttertoast.showToast(
        msg: "¡Rellena todos los campos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    print('Error de conexión: $e');
  }
}

Future<void> createDraftToBranches(String title, String content, int genreId, String date, int userId, String synopsis) async {
  try {
    var url = Uri.parse('https://yordi.terrabyteco.com/api/cdhistory');
    var response = await http.post(url, body: 
      {
        "title": title.toString(),
        "content": content.toString(),
        "genre_id": genreId.toString(),
        "date": date.toString(),
        "user_id": userId.toString(),
        "synopsis": synopsis.toString()
    });

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      historyDraftId = int.parse(responseData['history_id'].toString());
        print('Historia creada exitosamente, ID: $historyDraftId');
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => BranchesPage(historyId: historyDraftId)
          ),
        );
    } else {
      print('Error al crear la historia: ${jsonDecode(response.body)['mensaje']}');
    }
  } catch (e) {
    print('Error de conexión: $e');
      Fluttertoast.showToast(
        msg: "La historia debe estar terminada",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
  }
}

  void getCred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState( () {
      idUser = prefs.getInt('login_id')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            height: 1,
          ),
        ),
        title: const Text('Borrador'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder(
        future: _futureHistory,
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final history = snapshot.data!;
                          
          if (titleController.text.isEmpty) titleController.text = history.title;
          if (synopsisController.text.isEmpty) synopsisController.text = history.synopsis;
          if (contentController.text.isEmpty) contentController.text = history.content;

          return
          ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Termina de escribir tu historia!',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: currentWidth * 0.025,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7.5),
                    Column(
                      children: [

                        TextField(
                          controller: titleController,
                          cursorColor: Theme.of(context).secondaryHeaderColor,
                          cursorWidth: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Escribe el título aquí',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: synopsisController,
                          cursorColor: Theme.of(context).secondaryHeaderColor,
                          cursorWidth: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Escribe la sinopsis aquí',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: contentController,
                          cursorColor: Theme.of(context).secondaryHeaderColor,
                          cursorWidth: 1,
                          maxLines: 8,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Escribe el contenido aquí',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        FutureBuilder<List<Genre>>(
                          future: fetchGenres(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error al cargar los géneros');
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField<Genre>(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).colorScheme.secondary,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).secondaryHeaderColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    value: null,
                                    hint: Text('Seleccione el género', style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
                                    items: [
                                      for (var genre in snapshot.data!)
                                        DropdownMenuItem(
                                          value: genre,
                                          child: Text(genre.genre),
                                        ),
                                        
                                    ],
                                    onChanged: (selectedGenre) {
                                      setState(() {
                                        selectedGenreName = selectedGenre!.genre;
                                        selectedGenreId = selectedGenre.id;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(
                                    selectedGenreName.isNotEmpty ? 'Género: $selectedGenreName' : 'Sin género especificado',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: currentWidth * 0.025,
                                      color: Theme.of(context).colorScheme.tertiary
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 50,),
                        Text(
                          'No puedes agregar finales alternativos en borradores.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentWidth * 0.025,
                            color: Theme.of(context).colorScheme.tertiary
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
            }         
    }  ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Publicar historia", style: TextStyle(fontWeight: FontWeight.w500)),
                content: Text('¿Estás seguro de querer publicar esta historia?', style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.tertiary)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  ),
                  TextButton(
                    onPressed: () {
                      createHistory(
                        titleController.text,
                        contentController.text,
                        selectedGenreId,
                        formattedDate,
                        idUser,
                        synopsisController.text,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text("Sí", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        label: const Text(
          'Publicar historia',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}