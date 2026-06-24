import 'package:checkinlokasi/modules/login/data/login_api.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.network(
            "https://setda.sidoarjokab.go.id/images/profile/default.png",
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _userC,
            decoration: InputDecoration(labelText: "username", border: OutlineInputBorder()),
          ),
          SizedBox(height: 20),
          TextFormField(controller: _passwordC, obscureText: true),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              print(LoginApi().login("a@a.com", "123123"));
            },
            label: Text("LOGIN"),
            icon: Icon(Icons.login),
          ),
        ],
      ),
    );
  }
}
