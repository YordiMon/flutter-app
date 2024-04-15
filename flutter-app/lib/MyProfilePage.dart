import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/User.dart';
import 'package:project/models/History.dart';
import 'package:project/HistoryPage.dart';
import 'package:project/EditMyProfilePage.dart';
import 'package:project/NavigationMenu.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late Future<User> futureUser;
  late Future<List<History>> futureHistories;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    futureHistories = fetchHistories();
  }

  int numLikes = 0;
  int numComments = 0;

  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/user/${widget.id}'));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return User.fromJson(responseData as Map<String, dynamic>);
    } else {
      throw Exception('Fallo al cargar perfil');
    }
  }

  Future<List<History>> fetchHistories() async {
    final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/uhistory/${widget.id}'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => History.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Fallo al cargar las historias');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

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
        title: const Text('Mi perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NavigationMenu()),
            );
          },
        ),
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 75, right: 25, left: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 10),
                          Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: currentWidth * 0.05,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: currentWidth * 0.025,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'Sobre mi:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: currentWidth * 0.025,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        user.bio == null ? "No tienes biografía." : user.bio.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: currentWidth * 0.035,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditMyProfilePage(id: widget.id)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).colorScheme.background,
                          foregroundColor: Theme.of(context).colorScheme.tertiary,
                          side: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          maximumSize: const Size(75, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(Icons.create_outlined),
                      ),
                      const SizedBox(height: 75),
                      Text(
                        'Mis historias',
                        style: TextStyle(
                          fontSize: currentWidth * 0.025,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      PreferredSize(
                        preferredSize: const Size.fromHeight(1.0),
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 25),
                      FutureBuilder<List<History>>(
                        future: futureHistories,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return Container(
                              margin: EdgeInsets.only(left: currentWidth * 0.20, right: currentWidth * 0.20, top: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sin historias publicadas',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: currentWidth * 0.080,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  'Cuando publiques tus historias, tú y los demás usuarios las podrán ver aquí.',
                                  style: TextStyle(
                                    fontSize: currentWidth * 0.03,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context).colorScheme.tertiary
                                  ),
                                ),
                              ]
                            )
                            );
                            }
                            return Column(
                              children: snapshot.data!.map((history) => Container(
                                margin: const EdgeInsets.only(bottom: 25),
                                padding: const EdgeInsets.only(right: 20),
                                height: currentHeight * 0.20,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HistoryPage(id: history.id)),
                                    );
                                  },
                                  child: Row(
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
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              history.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: currentWidth * 0.04,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              history.synopsis,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.tertiary,
                                                fontSize: currentWidth * 0.03,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Género: ${history.genre}',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.tertiary,
                                                fontSize: currentWidth * 0.0225,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Autor: ${history.user}',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.tertiary,
                                                fontSize: currentWidth * 0.0225,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )).toList(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
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
