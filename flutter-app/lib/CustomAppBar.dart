import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          height: 1,
        ),
      ),
      title: const Row(
        children: [
          Text(
            'StoryBranch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ), 
          )
        ]
      ),
    );
  }
}