import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project/models/History.dart';
import 'package:project/models/User.dart';
import 'package:project/HistoryPage.dart';
import 'package:project/ProfilePage.dart';

enum SearchType {
  Title,
  Genre,
  Profile,
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<dynamic>> futureData;
  late TextEditingController _searchController;
  late SearchType _searchType;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchType = SearchType.Title;
    futureData = fetchResults('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchResults(String query) async {
    String apiUrl = '';
    switch (_searchType) {
      case SearchType.Title:
        apiUrl = 'https://yordi.terrabyteco.com/api/thistory/$query';
        break;
      case SearchType.Genre:
        apiUrl = 'https://yordi.terrabyteco.com/api/ghistory/$query';
        break;
      case SearchType.Profile:
        apiUrl = 'https://yordi.terrabyteco.com/api/nuser/$query';
        break;
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      if (_searchType == SearchType.Title || _searchType == SearchType.Genre) {
        return list.map((model) => History.fromJson(model)).toList();
      } else {
        return list.map((model) => User.fromJson(model)).toList();
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void search(String query, SearchType type) {
    setState(() {
      _searchType = type;
      futureData = fetchResults(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 25),
            child: TextField(
              controller: _searchController,
              cursorColor: Theme.of(context).secondaryHeaderColor,
              cursorWidth: 1,
              onChanged: (value) {
                search(value, _searchType);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: ' Buscar historias o perfiles',
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  search(_searchController.text, SearchType.Title);
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                  minimumSize: Size(currentWidth * 0.15, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book, size: currentWidth * 0.03),
                    Text(
                      '  Título',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: currentWidth * 0.025,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  search(_searchController.text, SearchType.Genre);
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                  minimumSize: Size(currentWidth * 0.15, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.autorenew_rounded, size: currentWidth * 0.035),
                    Text(
                      '  Género',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: currentWidth * 0.025,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  search(_searchController.text, SearchType.Profile);
                },
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                  minimumSize: Size(currentWidth * 0.15, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: currentWidth * 0.03),
                    Text(
                      '  Perfil',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: currentWidth * 0.025,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Container(
                  margin: EdgeInsets.only(left: currentWidth * 0.20, right: currentWidth * 0.20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No has buscado nada',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: currentWidth * 0.080,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Escribe en el campo de texto lo que sea que quieras buscar.',
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
                else {
                  List<dynamic> dataList = snapshot.data ?? [];
                  if (dataList.isEmpty) {
                    return Container(
                  margin: EdgeInsets.only(left: currentWidth * 0.20, right: currentWidth * 0.20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sin coincidencias',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: currentWidth * 0.070,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      'Lo que has buscado parece no existir por el momento.',
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
                  List<dynamic> dataList = snapshot.data ?? [];
                  if (_searchType == SearchType.Title || _searchType == SearchType.Genre) {
                    List<History> historyList = dataList.cast<History>();
                    return HistoryListWidget(histories: historyList);
                  } else {
                    List<User> userList = dataList.cast<User>();
                    return UserProfileListWidget(users: userList);
                  }
                }
              }}
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryListWidget extends StatelessWidget {
  final List<History> histories;

  const HistoryListWidget({Key? key, required this.histories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double currentWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: histories.map((history) => Container(
        margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        height: currentWidth * 0.4,
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
                  child: Image.asset('assets/logo.png'),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
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
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        history.synopsis,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        'Género: ${history.genre}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: MediaQuery.of(context).size.width * 0.0225,
                        ),
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        'Autor: ${history.user}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: MediaQuery.of(context).size.width * 0.0225,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }
}

class UserProfileListWidget extends StatelessWidget {
  
  final List<User> users;

  const UserProfileListWidget({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double currentWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: users.map((user) => InkWell(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ProfilePage(id: user.id)
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Icon( Icons.person, size: currentWidth * 0.1, ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: currentWidth * 0.030),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.bio == null ? "Sin biografía." : user.bio.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: currentWidth * 0.030),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }
}