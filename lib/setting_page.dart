import 'package:flutter/material.dart';
import 'home_page.dart';
import 'main.dart';


class SettingPage extends StatefulWidget {

  const SettingPage({Key? key, required this.setPage})
      : super(key: key);

  //following parameters MUST be passed:
  final Function(int index) setPage;



  @override
  State<SettingPage> createState() {
    return _SettingPageState();
  }
}


class _SettingPageState extends State<SettingPage> {
  // declare variables here:
  @override
  void dispose() {
    darkNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool isDark = darkNotifier.value;

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                    widget.setPage(-1);
              }),
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
                        activeColor: blueish(),
                        activeTrackColor: Colors.blue.shade700,
                        value: isDark,
                        onChanged: (_) {
                          setState(() {isDark = !isDark; darkNotifier.value = isDark;});
                        }
                      )
                      ),
                  ]
                ),


              ],
            ),
          ),
        ),
      
    );
  }
}


