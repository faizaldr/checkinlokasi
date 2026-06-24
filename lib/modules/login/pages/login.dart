import 'package:checkinlokasi/modules/location/pages/location.dart';
import 'package:checkinlokasi/modules/login/data/login_api.dart';
import 'package:checkinlokasi/modules/login/data/login_db.dart';
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
            decoration: InputDecoration(
              labelText: "username",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordC,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _handleLogin,
            label: Text("LOGIN"),
            icon: Icon(Icons.login),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    final username = _userC.text.trim();
    final password = _passwordC.text;
    final loginResponse = await LoginApi().login(username, password);
    if (loginResponse != null) {
      await LoginDb().saveToken(loginResponse.jwt!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Berhasil : ${loginResponse.user!.username}"),
        ),
      );
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LocationPage()));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Gagal")));
    }
  }
}
