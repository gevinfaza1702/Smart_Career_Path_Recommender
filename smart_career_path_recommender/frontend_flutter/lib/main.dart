import 'package:flutter/material.dart';
import 'recommendation_page.dart'; // ← tambahkan ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Career Recommender',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RecommendationPage(), // ← ganti halaman awal ke sini
    );
  }
}
