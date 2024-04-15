import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/models/History.dart';
import 'package:project/models/Branch.dart';

class ReadHistoryPage extends StatefulWidget {
  const ReadHistoryPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<ReadHistoryPage> createState() => _ReadHistoryPageState();
}

class _ReadHistoryPageState extends State<ReadHistoryPage> {
  late Future<History> futureHistory;
  late Future<List<Branch>> futureBranches;
  Branch? selectedBranch;

  @override
  void initState() {
    super.initState();
    futureHistory = fetchHistory();
    futureBranches = fetchBranches();
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

  Future<List<Branch>> fetchBranches() async {
    final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/branch/${widget.id}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body); 
      return responseData.map((data) => Branch.fromJson(data)).toList();
    } else {
      throw Exception('Fallo al cargar las ramas');
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
        title: const Text('Leer historia'),
      ),
      body: FutureBuilder(
        future: Future.wait([futureHistory, futureBranches]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            final history = snapshot.data![0] as History;
            final branches = snapshot.data![1] as List<Branch>;

            return ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, right: 25, left: 25, bottom: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        history.title,
                        textAlign: TextAlign.center,
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
                      const SizedBox(height: 75,),
                      Text(
                        history.content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: currentWidth * 0.035,
                        ),
                      ),
                      const SizedBox(height: 75,),

                      if (branches.isNotEmpty) ...[
                        Text(
                          'Elige tu camino',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: currentWidth * 0.025,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(
                          margin: const EdgeInsets.only(right: 25, left: 25, bottom: 25),
                          height: 130,
                          child: ListView.builder(
                            itemCount: branches.length,
                            itemBuilder: (context, index) {
                              final branch = branches[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedBranch = branch;
                                    });
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(500, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(branch.branchTitle),
                                ),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Esta historia no tiene finales alternativos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: currentWidth * 0.025,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                      if (selectedBranch != null)
                        Container(
                          margin: const EdgeInsets.only(left: 25, right: 25),

                          child: Column(
                            children: [
                              const SizedBox(height: 25,),
                              Text(
                                selectedBranch!.branchTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: currentWidth * 0.05,
                                ),
                              ),
                              const SizedBox(height: 25,),
                              Text(
                                selectedBranch!.branchContent,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: currentWidth * 0.035,
                                  color: Theme.of(context).colorScheme.tertiary
                                ),
                              ),
                              const SizedBox(height: 150,),
                            ],
                          ),
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
