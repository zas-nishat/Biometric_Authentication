import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'GoogleSignInProvider.dart';

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final GoogleSignInProvider _provider = GoogleSignInProvider();
  GoogleSignInAccount? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Listen for sign-in state changes
    _provider.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _provider.googleSignIn.signInSilently();
  }

  Future<void> _handleSignOut() async {
    setState(() {
      _isLoading = true;
    });

    // Perform sign out and wait for 2 seconds to show the loading indicator
    await _provider.signOut();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _currentUser = null;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Signed out successfully!")));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Sign-In")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _currentUser == null
                ? Text("No user signed in")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(_currentUser!.photoUrl ?? ''),
                        radius: 40,
                      ),
                      SizedBox(height: 10),
                      Text("Name: ${_currentUser!.displayName}"),
                      Text("Email: ${_currentUser!.email}"),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _handleSignOut,
                        child: Text("Logout"),
                      ),
                    ],
                  ),
      ),
    );
  }
}
