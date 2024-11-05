import 'package:flutter/material.dart';
import 'package:tanismart/Screen/Login/Login.dart';
import 'package:tanismart/Screen/OnBoarding/onBoarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanishmart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Onboarding(), // Menampilkan Onboarding terlebih dahulu
      routes: {
        '/login': (context) => const Login(), // Mengarahkan ke halaman login
      },
    );
  }
}
