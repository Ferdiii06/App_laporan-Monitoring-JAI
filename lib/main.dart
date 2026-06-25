import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const YazakiApp());
}

class YazakiApp extends StatelessWidget {
  const YazakiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yazaki',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB71C1C)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}