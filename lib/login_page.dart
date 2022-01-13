import 'package:flutter/material.dart';
import 'main.dart';

// This is only for setup and final (non-changable) variable definition
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  //following parameters MUST be passed:


  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

// Here is the layout and the action triggers
class _LoginPageState extends State<LoginPage> {
  // declare variables here:
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _firstnameTextController = TextEditingController();
  TextEditingController _lastnameTextController = TextEditingController();
  bool _showSignUp = false; //show either login screen or signup screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Image.asset(
          'assets/icon-round.png',
          fit: BoxFit.fitHeight,
          height: 40,
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "FraPods",
                  style: titleTextStyle(),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    style: normalTextStyle(),
                    controller: _usernameTextController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Username'),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    style: normalTextStyle(),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _passwordTextController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                  ),
                ),

                Visibility(
                  visible: _showSignUp,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _firstnameTextController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Firstname'),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _lastnameTextController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Lastname'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: OutlinedButton(
                                  onPressed: () =>
                                      signUp(
                                        _usernameTextController.text.trim(),
                                        _passwordTextController.text.trim(),
                                        _firstnameTextController.text.trim(),
                                        _lastnameTextController.text.trim(),
                                      ),
                                  child: const Text("Sign Up")),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _showSignUp = false;
                            });
                          },
                          child: Text("Already have an account? Log In"),
                      ),
                    ],
                  ),
                ),

                Visibility(
                  visible: !_showSignUp,
                  child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  logIn(
                                      _usernameTextController.text.toString(),
                                      _passwordTextController.text.toString()
                                  ),
                              child: const Text("Log In"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: (){
                          setState(() {
                            _showSignUp = true;
                          });
                        },
                        child: Text("Don't have an account? Sign Up")
                    )
                    ],
                  ),
                ),


                // Layout with Sign Up button

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Write class-internal methods here

  void logIn(String username, String password) {
    if (username.isEmpty) {
      showDialogMessage("Login failed", "Please enter a username!");
      return;
    }
    if (password.isEmpty) {
      showDialogMessage("Login failed", "Please enter a password!");
      return;
    }
    //TODO: write login request to server HERE
  }

  void signUp(String username, String password, String firstname, String lastname) {
    if (username.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter a username!");
      return;
    }
    if (password.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter a password!");
      return;
    }
    if (firstname.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter your firstname!");
      return;
    }
    if (lastname.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter your lastname!");
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
