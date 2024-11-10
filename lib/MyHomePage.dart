import 'package:biometric_auth/Google%20Map/GHome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator

import 'Services/Biometric Auth Service.dart';
import 'Second Page for Biometric Test.dart';
import 'SplashScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isAuthenticated = false;
  bool _showBalance = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    final bool didAuthenticate = await AuthService.authenticate();
    if (didAuthenticate) {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      // If authentication fails, close the app
      SystemNavigator.pop();
    }
  }

  Future<void> _navigateToSecurePage() async {
    final bool didAuthenticate = await AuthService.authenticate();
    if (didAuthenticate) {
      Get.to(SecurePage()
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access denied. Authentication failed. ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return SplashScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Auth"),
        centerTitle: true,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: _navigateToSecurePage, // Navigate on button press
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(GHomePage());
        },
        child: Icon(
          _showBalance ? Icons.lock_clock_outlined : Icons.fingerprint,
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Account Balance",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _showBalance ?
              "\$6,59,970" : "******",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
