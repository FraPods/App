import 'package:flutter/material.dart';
import 'home_page.dart';


class SettingPage extends StatefulWidget {

  const SettingPage({Key? key, /*required this.podcastInfo*/})
      : super(key: key);

  //following parameters MUST be passed:
  @override
  State<SettingPage> createState() {
    return _SettingPageState();
  }
}


class _SettingPageState extends State<SettingPage> {
  // declare variables here:


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text("This is the setting page")
              ],
            ),
          ),
        ),
      ),
    );
  }
}


