import 'package:flutter/material.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('欢迎页'),),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              //跳到登录页
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text("前往登录")
        ),
      ),
    );
  }
}