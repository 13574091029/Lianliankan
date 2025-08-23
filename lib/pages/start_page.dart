import 'package:flutter/material.dart';
import 'lianliankan.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text(
            '连连看',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GamePage()),
            );
          },
        ),
      ),
    );
  }
}