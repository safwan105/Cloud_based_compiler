import 'package:cloude/pages/login_or_register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  String url = 'http://20.193.147.179:5000//create';
  Map<String, String> headers = {
    'Content-type': 'application/x-www-form-urlencoded'
  };

  void createFolder() async {
    final user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;
    String data = 'userId=$email';
    // print(user);
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            createFolder();
            return HomePage();
          } else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
