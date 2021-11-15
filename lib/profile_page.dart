import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title, required this.username})
      : super(key: key);

  //following parameters MUST be passed:
  final String title;
  final String username;

  @override
  State<ProfilePage> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  // declare variables here:
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(padding: EdgeInsets.all(16.0),
          child: Icon(Icons.account_circle),
        )

      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[Text("This is the account page of the app")],
            ),
          ),
        ),
      ),
    );
  }
}
