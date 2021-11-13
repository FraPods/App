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
  String _lol = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text("FraPods"),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'e-mail-address'

                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password'
              ),
            ),
          ),


            // Layout with Sign In button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
              children: <Widget> [Expanded(

                child: OutlinedButton(onPressed: logIn,

                  child: const Text(
                "Sign In"
                ),
              ),
            ),

            ],
          ),
        ),



            // Layout with Sign Up button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Row(
                children: <Widget> [Expanded(

                  child: OutlinedButton(onPressed: logIn,

                      child: const Text(
                          "Sign Up"
                      )
                  ),
                ),

                ],
              ),
            ),

          ],
        ),
      ),
    ),
    );
  }

  void logIn(){

  }

}