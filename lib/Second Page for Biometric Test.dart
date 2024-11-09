import 'package:flutter/material.dart';

class SecurePage extends StatelessWidget {
  const SecurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Page"),
        centerTitle: true,
      ),
      body: Center(
        child: const Text(
          "This is a secure page that requires authentication.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
