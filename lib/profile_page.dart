import 'package:flutter/material.dart';
import 'setting_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.setPage})
      : super(key: key);

  //following parameters MUST be passed:
  final Function(int index) setPage;

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
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;

    return Scaffold(
      appBar: AppBar(
           title: Icon(Icons.account_circle),
           actions: [
           IconButton(icon: Icon(Icons.settings),
            onPressed: () {
              widget.setPage(4);
            },)
         ],
      ),
      body: Container(
        height: pageHeight,
        child: ListView(
          children: [Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Center(child: Column(
                children: <Widget>[
                  Card(
                    //margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      height: pageHeight /4,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Row(children: [
                          Container(decoration: BoxDecoration(border: Border.all(color: Colors.pink, width: 2)),
                          height: 20,width: 50,)

                        ],)
                      ],)
                    )
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
