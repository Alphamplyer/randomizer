
import 'package:flutter/material.dart';
import 'package:randomizer/src/pages/home.dart';

class RandomizerApp extends StatefulWidget {
  const RandomizerApp({Key? key}) : super(key: key);

  @override
  State<RandomizerApp> createState() => _RandomizerAppState();
}

class _RandomizerAppState extends State<RandomizerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Randomizer',
      theme: ThemeData.dark().copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}