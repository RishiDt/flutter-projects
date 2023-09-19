import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String text;
  const HomePage({this.text = "empty", Key? key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("jwt_auth_app"),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text),
            ],
          )),
    );
  }
}
