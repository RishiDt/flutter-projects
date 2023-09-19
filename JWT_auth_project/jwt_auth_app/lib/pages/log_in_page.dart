import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:jwt_auth_app/pages/home_page.dart';

import 'package:http/http.dart' as http;
import 'package:jwt_auth_app/config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _valid = true;
  bool _isLogIn = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> registerUser() async {
    if (_controllerEmail.text.isNotEmpty &&
        _controllerPassword.text.isNotEmpty) {
      final uri = Uri.parse(config.url + config.regApiPath);

      var regBody = {
        "email": _controllerEmail.text,
        "password": _controllerPassword.text
      };

      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    text: _controllerEmail.text,
                  )),
        );
      }
    } else {
      _valid = false;
    }
  }

  Future<void> logInUser() async {
    if (_controllerEmail.text.isNotEmpty &&
        _controllerPassword.text.isNotEmpty) {
      final uri = Uri.parse(config.url + config.logInApiPath);

      var regBody = {
        "email": _controllerEmail.text,
        "password": _controllerPassword.text
      };

      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", jsonResponse['token']);

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(
                    text: "user Logged In",
                  )),
        );
      }
    } else {
      _valid = false;
    }
  }

  Widget _title() {
    return const Text('jwt_auth');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        errorText: _valid ? '$title not entered' : "",
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: _isLogIn ? logInUser : registerUser,
        child: Text(_isLogIn ? "LogIn" : "Register"));
  }

  Widget _textButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            _isLogIn = !_isLogIn;
          });
        },
        child: Text(_isLogIn ? "Register Insted" : "Log In Instead"));
  }

  Widget _container() {
    return Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            _submitButton(),
            _textButton()
          ],
        ));
  }

  Future<bool> checkLogInStatus() async {
    final uri = Uri.parse(config.url + config.logInApiPath);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    print("i am in checkLogInStatus  ");
    if (token == null) {
      return false;
    }
    if (token.isNotEmpty) {
      var reqBody = {"token": token};

      print("i am in checkLogInStatus and token is not empty");
      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var decodeJson = jsonDecode(response.body);

      if (decodeJson['status']) {
        return true;
      } else
        false;
    }
    print("i am in checkLogInStatus and token is  empty");
    return false;
  }

  Widget centerTextWidget() {
    return const Center(
      child: Text("plz wait"),
    );
  }

  goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const HomePage(
                text: "user Logged In",
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: FutureBuilder(
        future: checkLogInStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen.
            return const Center(child: Text("Plz wait.."));
          } else if (snapshot.hasError) {
            // Show error message.
            return Text(snapshot.error.toString());
          } else {
            if (snapshot.data == true) return goToHomePage();
            // Show the data that was returned from the future.
            return _container();
          }
        },
      ),
    );
  }
}
