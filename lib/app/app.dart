import 'package:flutter/material.dart';

import '../screens/homescreen.dart';

class LibraryManagementSystem extends StatelessWidget {
  const LibraryManagementSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase App',
      home: const MyHomePage(),

    );
  }
}