import 'package:flutter/material.dart';
import 'home_page.dart';
import 'main.dart';


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
  bool darkModeSwitchOn = true;

  void toggleDarkModeSwitch (bool value){
    if (darkModeSwitchOn == false) {
      setState(() {
        darkModeSwitchOn = true;
      });
    }else{
      setState(() {
        darkModeSwitchOn = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings')
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 10),
                  child: Text("Basic Settings", 
                    style: subtitleTextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(15, 0, 20, 5),
                      child: Text("Dark Mode:", 
                        style: normalTextStyle2(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    
                      Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleDarkModeSwitch,
                          value: darkModeSwitchOn,
                          activeColor: Colors.white70,
                          activeTrackColor: Colors.blue[600],
                          inactiveThumbColor: Colors.white70,
                          inactiveTrackColor: Colors.grey[800],
                        ),
                      ),
                  ]
                )
                
                
              ],
            ),
          ),
        ),
      
    );
  }
}


