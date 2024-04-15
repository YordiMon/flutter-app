import 'package:flutter/material.dart';
import 'package:project/CustomAppBar.dart';


class HistoriesPage extends StatefulWidget {
  const HistoriesPage({super.key, required this.title});

  final String title;

  @override
  State<HistoriesPage> createState() => _HistoriesPageState();
}

class _HistoriesPageState extends State<HistoriesPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(),

      body: ListView(
        
      ),
    );
  }
}