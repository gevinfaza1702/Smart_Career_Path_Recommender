import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({Key? key}) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final Map<String, bool> _skills = {
    'Python': false,
    'SQL': false,
    'Flutter': false,
    'Laravel': false,
  };

  String? _career;
  List<dynamic> _recommendations = [];

  Future<void> _getRecommendation() async {
    final selected =
        _skills.entries.where((e) => e.value).map((e) => e.key).toList();
    final response = await http.post(
      Uri.parse('http://localhost:5000/predict-career'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'skills': selected}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _career = data['career'] as String?;
        _recommendations = List<String>.from(data['recommendations'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career Recommendation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih skill kamu:'),
            ..._skills.keys.map((skill) => CheckboxListTile(
                  title: Text(skill),
                  value: _skills[skill],
                  onChanged: (val) {
                    setState(() {
                      _skills[skill] = val ?? false;
                    });
                  },
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getRecommendation,
              child: const Text('Lihat Rekomendasi'),
            ),
            if (_career != null)
              Card(
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Karier: \$_career',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Rekomendasi Belajar:'),
                      ..._recommendations.map((r) => Text('- $r')),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
