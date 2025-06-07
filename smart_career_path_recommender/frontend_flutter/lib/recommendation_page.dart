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
  bool _isLoading = false;

  Future<void> _getRecommendation() async {
    final selected =
        _skills.entries.where((e) => e.value).map((e) => e.key).toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pilih minimal satu skill terlebih dahulu.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/predict-career'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'skills': selected}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _career = data['career'] as String?;
          _recommendations = List<String>.from(data['recommendations'] ?? []);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Gagal mendapatkan rekomendasi. (${response.statusCode})')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghubungi server.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('💼 Career Recommender'),
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🧠 Pilih skill kamu:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _skills.keys
                    .map((skill) => FilterChip(
                          label:
                              Text(skill, style: const TextStyle(fontSize: 16)),
                          selected: _skills[skill]!,
                          onSelected: (val) {
                            setState(() {
                              _skills[skill] = val;
                            });
                          },
                          selectedColor: Colors.deepPurple.shade100,
                          checkmarkColor: Colors.deepPurple,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.deepPurple)
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                        ),
                        onPressed: _getRecommendation,
                        icon: const Icon(Icons.search),
                        label: const Text('Lihat Rekomendasi',
                            style: TextStyle(fontSize: 16)),
                      ),
              ),
              if (_career != null)
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.work_outline,
                                color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Karier yang Cocok: $_career',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('📚 Rekomendasi Belajar:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        ..._recommendations
                            .map((r) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline,
                                          size: 18, color: Colors.deepPurple),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(r)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
