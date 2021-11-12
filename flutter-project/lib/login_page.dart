import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget{

  const LoginPage({Key? key, required this.title}) : super(key: key);

  //following parameters MUST be passed:
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  // declare variables here:

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'This is the login page of the app. ',
            ),
          ],
        ),
      ),
    );
  }
}