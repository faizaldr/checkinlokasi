import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.network(
            "https://setda.sidoarjokab.go.id/images/profile/default.png"
          ),
          SizedBox(height: 20),
          TextFormField(),
          SizedBox(height: 20),
          TextFormField(),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            label: Text("LOGIN"),
            icon: Icon(Icons.login),
          ),
        ],
      ),
    );
  }
}