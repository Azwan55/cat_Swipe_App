
import 'package:cat_swipe_app/pages/CatSwipePage.dart';
import 'package:cat_swipe_app/pages/SummaryPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cat {
  final int index;
  final String imageUrl;

  Cat({required this.index, required this.imageUrl});
}

void main() {
  runApp(CatSwipeApp());
}

class CatSwipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paws & Preferences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatSwipePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

