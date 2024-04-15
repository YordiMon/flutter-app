import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/History.dart';
import 'package:project/models/Comment.dart';
import 'package:project/ReadHistoryPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextEditingController commentController = TextEditingController();
  late Future<History> futureHistory;
  late Future<List<Comment>> futureComments;
  late int id;

  @override
  void initState() {
    super.initState();
    getUserId();
    futureHistory = fetchHistory();
    futureComments = fetchComments();
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState( () {
      id = prefs.getInt('login_id')!;
    });
  }

  int numLikes = 0;
  int numComments = 0;

Future<History> fetchHistory() async {
  final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/history/${widget.id}'));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body); 
    numLikes = responseData['likes_count'];
    numComments = responseData['comments_count'];
    return History.fromJson(responseData as Map<String, dynamic>);
  } else {
    throw Exception('Fallo al cargar la historia');
  }
}

Future<List<Comment>> fetchComments() async {
  final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/comments/${widget.id}'));
  
  if (response.statusCode == 200) {
    List<Comment> comments = [];
    var jsonData = json.decode(response.body);
    for (var item in jsonData) {
      comments.add(Comment.fromJson(item));
    }
    return comments;
  } else {
    throw Exception('Failed to load comments');
  }
}

  Future<void> registerComment() async {
    String comment = commentController.text.toString();

    var url = Uri.parse('https://yordi.terrabyteco.com/api/createcomment');
    var response = await http.post(url, body: 
    {
      "comment": comment,
      "user_id": id.toString(),
      "history_id": widget.id.toString()
    }
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == 'success') {
        Fluttertoast.showToast(
          msg: "Comentario registrado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );     

        setState(() {
              futureComments = fetchComments();
            });
          }
    } else {
      throw Exception('Fallo al crear comentario. Intentelo mas tarde.');
    }
  }

    Future<void> registerLike() async {

    var url = Uri.parse('https://yordi.terrabyteco.com/api/like');
    var response = await http.post(url, body: 
    {
      "user_id": id.toString(),
      "history_id": widget.id.toString()
    }
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == 'success') {
        Fluttertoast.showToast(
          msg: "Realizado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );     

        setState(() {
              futureHistory = fetchHistory();
            });
          }
    } else {
      throw Exception('Fallo al crear like. Intentelo mas tarde.');
    }
  }

    Future<void> registerSave() async {

    var url = Uri.parse('https://yordi.terrabyteco.com/api/save');
    var response = await http.post(url, body: 
    {
      "user_id": id.toString(),
      "history_id": widget.id.toString()
    }
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == 'success') {
        Fluttertoast.showToast(
          msg: "Realizado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );     

        setState(() {
              futureComments = fetchComments();
            });
          }
    } else {
      throw Exception('Fallo al crear guardado. Intentelo mas tarde.');
    }
  }


  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
      
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
        title: const Text('Historia'),
      ),
      body: FutureBuilder<History>(
        future: futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            final history = snapshot.data!;
            return ListView(
              children: [

                Container(
                  margin: const EdgeInsets.only(top:25, right: 25, left: 25),

                  child: 
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                        Text(
                          history.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: currentWidth * 0.05,
                          ),
                        ),
          
                    const SizedBox(height: 5,),
                    Text(
                      'Autor: ${history.user}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: currentWidth * 0.025,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/logo.png',
                        scale: currentWidth * 0.001,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ReadHistoryPage(id: history.id)
                          ),
                        );
                      }, 
                      
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(500, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),


                      child: const Text(
                        'Leer historia'
                      ),
                      
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                          'Género: ${history.genre}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: currentWidth * 0.025,
                          ),
                        ),
                        Text(
                          'Fecha: ${history.date}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: currentWidth * 0.025,
                          ),
                        ),
                      ]
                    ),
                    const SizedBox(height: 25,),
                    Text(
                      'Sinopsis:',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: currentWidth * 0.025,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 2.5,),
                    Text(
                      history.synopsis,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontSize: currentWidth * 0.035,
                      ),
                    ),

                    const SizedBox(height: 100,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          'Deja tu comentario:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: currentWidth * 0.025,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ]
                    ),
                    const SizedBox(height: 5,),
                    TextField(
                      controller: commentController,
                      onSubmitted: (String value) {
                        registerComment();
                      },
                      cursorColor: Theme.of(context).secondaryHeaderColor,
                      cursorWidth: 1,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.send, size: currentWidth * 0.04),     
                        hintText: ' ¿Qué piensas de esta historia?',

                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color:Theme.of(context).colorScheme.secondary,
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

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        numLikes.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: currentWidth * 0.03,
                          color: Theme.of(context).colorScheme.tertiary
                        ),  
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: registerLike,
                        icon: Icon(Icons.favorite_border_rounded, size: currentWidth * 0.04, color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(width: 50),
                      Text(
                        numComments.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: currentWidth * 0.03,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {

                        },
                        icon: Icon(Icons.chat_outlined, size: currentWidth * 0.04, color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(width: 50),
                      IconButton(
                        onPressed: registerSave,
                        icon: Icon(Icons.bookmark_outline_rounded, size: currentWidth * 0.04, color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ],
                  ),


                  const SizedBox(height: 25,),

                    PreferredSize(
                      preferredSize: const Size.fromHeight(1.0),
                      child: Container(
                        color: Theme.of(context).colorScheme.primary,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 15,),

                    FutureBuilder<List<Comment>>(future: futureComments,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,

                            children: snapshot.data!.map((comment) =>
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(25),
                                width: 500,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person, size: currentWidth * 0.035),
                                        const SizedBox(width: 5,),
                                        Text(comment.user, style: TextStyle(fontWeight: FontWeight.bold, fontSize: currentWidth * 0.030)),
                                      ]
                                    ),

                                    Text(comment.comment, style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: currentWidth * 0.030),),
                                  ]
                                ),

                            )).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else if (snapshot.hasData == false) {
                          return Text('No has creado ninguna historia por el momento.');
                        }

                        return const CircularProgressIndicator();
                      },
                    ),

                    const SizedBox(height: 15,)
                  ]
                )
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      ),
    );
  }
}
