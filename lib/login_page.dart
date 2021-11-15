import 'package:flutter/material.dart';
import 'main.dart';

// This is only for setup and final (non-changable) variable definition
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  //following parameters MUST be passed:
  final String title;

  @override
  State<StatefulWidget> createState() {

    return _LoginPageState();
  }
}

// Here is the layout and the action triggers
class _LoginPageState extends State<LoginPage> {
  // declare variables here:
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/icon-round.png', fit: BoxFit.fitHeight, height: 40,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "FraPods",
                  style: titleTextStyle(),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _emailTextController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Mail Address'),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _passwordTextController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                  ),
                ),

                // Layout with Log In button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => logIn(
                              _emailTextController.text.toString(),
                              _passwordTextController.text.toString()),
                          child: const Text("Log In"),
                        ),
                      ),
                    ],
                  ),
                ),

                // Layout with Sign Up button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () => signUp(
                                _emailTextController.text.trim(),
                                _passwordTextController.text.trim()),
                            child: const Text("Sign Up")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Write class-internal methods here

  void logIn(String email, String password) {
    if (email.isEmpty) {
      showDialogMessage("Login failed", "Please enter an E-Mail Address!");
      return;
    }
    if (password.isEmpty) {
      showDialogMessage("Login failed", "Please enter a password!");
      return;
    }
    //TODO: write login request to server HERE
  }

  void signUp(String email, String password) {
    if (email.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter an E-Mail Address!");
      return;
    }
    if (password.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter a password!");
      return;
    }
    //TODO: write signup request to server HERE
  }

  void showDialogMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// All class-internal methods should go above this line
}
