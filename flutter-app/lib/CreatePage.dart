import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/CreateHistoryPage.dart';
import 'package:project/FinishDraft.dart';
import 'package:project/models/History.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key, required this.id});

  final int id;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  late Future<List<History>> futureHistory;

  Future<List<History>> fetchHistory() async {
    final response =
        await http.get(Uri.parse('https://yordi.terrabyteco.com/api/udhistory/${widget.id}'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => History.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Fallo al cargar la historia');
    }
  }

  Future<void> deleteHistory(int id) async {
    try {
      final response = await http.post(
        Uri.parse('https://yordi.terrabyteco.com/api/dfdah-history'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          'history_id': id,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Borrador eliminado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_LEFT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Historia y borrador eliminados exitosamente');
        setState(() {
          futureHistory = fetchHistory();
        });
      } else {
        print('Error al eliminar la historia y el borrador');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureHistory = fetchHistory();
  }

  Widget _buildConfirmationDialog(BuildContext context, int historyId) {
    return AlertDialog(
      title: const Text("Borrador", style: TextStyle(fontWeight: FontWeight.w500)),
      content: Text('¿Qué quieres hacer con el borrador?', style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.tertiary)),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            deleteHistory(historyId);
          },
          child: Text('Eliminar', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FinishDraft(id: historyId)),
            );
          },
          child: Text('Continuar', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double currentWidth = MediaQuery.of(context).size.width;
    final double currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 50, right: 25, left: 25, bottom: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateHistoryPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(500, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Crear nueva historia'),
            ),
          ),
          Text('Tus borradores',
            style: TextStyle(
              fontSize: currentWidth * 0.025,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10,),
          PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<History>>(
              future: futureHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  List<History> drafts = snapshot.data ?? [];
                  if (drafts.isEmpty) {
                    return Container(
                  margin: EdgeInsets.only(left: currentWidth * 0.20, right: currentWidth * 0.20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No has escrito nada aún',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: currentWidth * 0.080,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Comienza a escribir y las historias que dejes sin terminar se almacenarán aquí.',
                      style: TextStyle(
                        fontSize: currentWidth * 0.03,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.tertiary
                      ),
                    ),
                  ]
                )
                );
                  } else {
                    return ListView(
                      children: drafts.map((history) => Container(
                        margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
                        height: currentHeight * 0.125,
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return _buildConfirmationDialog(context, history.id);
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.restore_from_trash, size: currentWidth * 0.05),
                                      const SizedBox(height: 7.5,),
                                      Text(
                                        history.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: currentWidth * 0.03,
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ]
                            )
                          )
                        )
                      )).toList(),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 25,)
        ],
      ),
    );
  }
}
