import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('主页'),),
      body: Center(
        child: Text('你好, $username！', style: TextStyle(fontSize: 24),),
      ),
    );
  }
}