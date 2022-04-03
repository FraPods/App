import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';
import 'main.dart';
import 'backend_api.dart';

// This is only for setup and final (non-changable) variable definition
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);




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
  TextEditingController _emailTextController = TextEditingController();
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
                            controller: _lastnameTextController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Lastname'),
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: TextField(
                            controller: _emailTextController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'E-Mail'),
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
                                          _emailTextController.text.trim(),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      logIn(
                                          _usernameTextController.text
                                              .toString(),
                                          _passwordTextController.text
                                              .toString()
                                      ),
                                  child: const Text("Log In"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                            onPressed: () {
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

  Future<void> logIn(String username, String password) async {
    if (username.isEmpty) {
      showDialogMessage("Login failed", "Please enter a username!");
      return;
    }
    if (password.isEmpty) {
      showDialogMessage("Login failed", "Please enter a password!");
      return;
    } else {
      String result = await BackendApi().logIn(username, password);
      switch(result){
        case "200":
          showDialogMessage("Login: authentication", "FraPods uses 2 factor authentication. You will receive an E-Mail asking you to verify this device. Click the link and then restart this app to log in!");
          break;
      }
    }

  }




  Future<void> signUp(String username, String password, String firstname, String lastname, String email) async {
    if (username.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter a username!");
      return;
    } else if (password.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter a password!");
      return;
    } else if (firstname.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter your firstname!");
      return;
    } else if (lastname.isEmpty) {
      showDialogMessage("Sign Up failed", "Please enter your lastname!");
      return;
    } else if (email.isEmpty){
      showDialogMessage("Sign Up failed", "Please enter your E-Mail address");
    } else {
      //TODO Waiting animation here (eg. circle spinning").

      String result = await BackendApi().createAccount(username, password, firstname, lastname, email);
      switch(result){
        case "200":
          showDialogMessage("Registration successfulf!", "The registration was successful. You can now log in!");
          setState(() {
            _showSignUp = false;
          });
          break;
      }
    }
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
