// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:asset_api/components/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 218, 224, 251),
      ),
      home: const SearchPage(),
    );
  }
}
