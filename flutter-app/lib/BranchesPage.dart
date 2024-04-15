import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project/NavigationMenu.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({Key? key, required this.historyId}) : super(key: key);

  final int historyId;

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  TextEditingController titleTwoController = TextEditingController();
  TextEditingController contentTwoController = TextEditingController();

  Future<void> createBranches(String title, String content, String title2, String content2) async {

  try {
    var url = Uri.parse('https://yordi.terrabyteco.com/api/cbranch');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode([
        {
          "branch_title": title,
          "branch_content": content,
          "history_id": widget.historyId
        },
        {
          "branch_title": title2,
          "branch_content": content2,
          "history_id": widget.historyId
        }
      ]),
    );

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

  Future<void> deleteHistoryFromDrafts() async {
    try {
      final response = await http.post(
        Uri.parse('https://yordi.terrabyteco.com/api/ddraft/${widget.historyId}'));

      if (response.statusCode == 200) {
        print('Error al eliminar la historia y el borrador');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
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
        title: const Text('¿Más de un final?'),
      ),

      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '¡Agrega finales alternativos!',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: currentWidth * 0.025,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NavigationMenu()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.tertiary,
                        minimumSize: const Size(100, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: currentWidth * 0.025,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7.5),
                Text(
                  'En caso de no querer agregar finales alternativos, puedes simplemente pulsar el botón "cancelar" para volver a la página principal, no te preocupes por la historia que hayas escrito, se guarda en borradores automaticamente (los finales alternativos no se guardan en borradores).',
                  style: TextStyle(
                    fontSize: currentWidth * 0.025,
                    color: Theme.of(context).colorScheme.tertiary
                  ),
                ),
                const SizedBox(height: 50,),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [
                      TextField(
                      controller: titleController,
                      cursorColor: Theme.of(context).secondaryHeaderColor,
                      cursorWidth: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Título del final 1',
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
                      maxLines: 6,
                      controller: contentController,
                      cursorColor: Theme.of(context).secondaryHeaderColor,
                      cursorWidth: 1,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Contenido del final 1',
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
                    ]
                  )
                ),
                const SizedBox(height: 15,),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [
                      TextField(
                      controller: titleTwoController,
                      cursorColor: Theme.of(context).secondaryHeaderColor,
                      cursorWidth: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Título del final 2',
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
                      maxLines: 6,
                      controller: contentTwoController,
                      cursorColor: Theme.of(context).secondaryHeaderColor,
                      cursorWidth: 1,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Contenido del final 2',
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
                    ]
                  )
                ),
                const SizedBox(height: 75,)
              ],
            ),
          ),
          
        ],
      ),
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
                      createBranches(
                        titleController.text,
                        contentController.text,
                        titleTwoController.text,
                        contentTwoController.text,
                      );
                      deleteHistoryFromDrafts();
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
