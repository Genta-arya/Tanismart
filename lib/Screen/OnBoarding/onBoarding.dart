import 'package:flutter/material.dart';
import 'package:tanismart/Screen/Login/Login.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''), 
        backgroundColor: Colors.white, 
        iconTheme: const IconThemeData(color: Colors.green), 
      ),
      body: Container(
        color: Colors.white, 
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          
                Image.network(
                  'https://api.hkks.shop/uploads/WhatsApp-Image-2024-11-05-at-18.59.01_e7e76b88-1730808036598.jpg',
                  height: 90, 
                  fit: BoxFit.cover, 
                ),
                const SizedBox(height: 20.0), 
            
                const Text(
                  "Selamat Datang",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, 
                  ),
                ),
                const SizedBox(height: 50.0),
            
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text("Silahkan Login", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: Colors.green, 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
