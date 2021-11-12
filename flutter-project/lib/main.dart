import 'package:flutter/material.dart';

// import all class files (create one class per page)
import 'home_page.dart';
import 'login_page.dart';

void main() {
  runApp(const FraPodsApp());
}

// Instanciate App
class FraPodsApp extends StatelessWidget {
  const FraPodsApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FraPods',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'FraPods - Podcast Sharing'),
    );
  }
}
