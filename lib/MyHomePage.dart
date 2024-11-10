import 'package:biometric_auth/Google%20Map/GHome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator

import 'Google Sign In/GoogleSignInPage.dart';
import 'Google Sign In/GoogleSignInProvider.dart';
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
  final GoogleSignInProvider _provider = GoogleSignInProvider();
  GoogleSignInAccount? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
    // Listen for sign-in state changes
    _provider.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _provider.googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final userCredential = await GoogleSignInProvider.signInWithGoogle();

    setState(() {
      _isLoading = false;
    });

    if (userCredential != null) {
      final userName = userCredential.user?.displayName ?? "User";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Welcome, $userName!")));
      Get.to(GoogleSignInPage());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-in failed. Please try again.")));
    }
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
          Icons.location_on_rounded
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _handleSignIn,
              icon: Icon(Icons.account_circle),
              label: Text("Sign in with Google"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(250, 50),
                side: BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),SizedBox(height: 20),
            Text(
              "Account Balance",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                setState(() {
                  _showBalance = !_showBalance;
                });
              },
              child: Text(
                _showBalance ?
                "\$6,59,970" : "Tap to view",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
