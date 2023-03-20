import 'package:flutter/material.dart';
import 'package:save_password_project_1/auth_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: FloatingActionButton.extended(
          onPressed: () {
            if (kIsWeb) {
              // running on the web!
              AuthService().signInWithGoogleWeb();
            } else {
              // NOT running on the web! You can check for additional platforms here.
              AuthService().signInWithGoogle();
            }
          },
          icon: Image.asset(
            'assets/images/google_logo.png',
            height: 32,
            width: 32,
          ),
          label: const Text("Signin with Google"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}
