import 'package:flutter/material.dart';
import 'package:hypixel_stat_tracker/hypixel_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hypixel Comparer',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final HypixelService _service = HypixelService();
  String? _resultText;

  Future<void> _seeStats() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _resultText = 'Please enter a username.';
      });
      return;
    }

    final kills = await _service.getBedwarsKills(username);
    setState(() {
      _resultText = 'Kills: $kills';
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _seeStats,
              child: const Text('See Stats'),
            ),
            const SizedBox(height: 20),
            if (_resultText != null)
              Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text(_resultText!),
              ),
          ],
        ),
      ),
    );
  }
}