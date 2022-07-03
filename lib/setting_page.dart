import 'package:flutter/material.dart';
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
  // void dispose() {
  //   darkNotifier.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    bool isDark = darkNotifier.value;

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                    widget.setPage(-1);
              }),
        title: const Text('Settings')
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 10),
                  child: Text("Basic Settings",
                    style: subtitleTextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(15, 0, 20, 5),
                      child: Text("Dark Mode:", 
                        style: normalTextStyle2(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 1.2,
                      child: Switch(
                        activeColor: blueish(),
                        activeTrackColor: Colors.blue.shade700,
                        value: darkNotifier.value,
                        onChanged: (_) {
                          saveBool(DARKMODE_ACTIVATED_KEY, !darkNotifier.value);
                          isDarkModeActivated = !isDarkModeActivated;
                          setState(() {darkNotifier.value = !darkNotifier.value;});
                        }
                      )
                      ),
                  ]
                ),

                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 10),
                  child: Text("Sources",
                    style: subtitleTextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(15, 0, 20, 5),
                        child: Text("FraPods:",
                          style: normalTextStyle2(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const Spacer(),
                      Transform.scale(
                          scale: 1.2,
                          child: Switch(
                              activeColor: blueish(),
                              activeTrackColor: Colors.blue.shade700,
                              value: isFrapodsSourceActivated,
                              onChanged: (_) {
                                isFrapodsSourceActivated = !isFrapodsSourceActivated;
                                setState(() {
                                });
                              }
                          )
                      ),
                    ]
                ),
                Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(15, 0, 20, 5),
                        child: Text("Youtube:",
                          style: normalTextStyle2(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const Spacer(),
                      Transform.scale(
                          scale: 1.2,
                          child: Switch(
                              activeColor: blueish(),
                              activeTrackColor: Colors.blue.shade700,
                              value: isYoutubeSourceActivated,
                              onChanged: (_) {
                                isYoutubeSourceActivated = !isYoutubeSourceActivated;
                                setState(() {
                                });
                              }
                          )
                      ),
                    ]
                ),

              // Logout Button
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.92,
                child: const Divider(thickness: 1,color: Colors.grey,)),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextButton(child: const Text('log out'),
                style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                          foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
                          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 18)),
                          fixedSize: MaterialStateProperty.all(const Size(double.maxFinite, 40)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                          ),
                        ),
                  onPressed: (){
                    setState(() {
                      loginNotifier.value = false;
                    });
                  }
                ),
              )

              ],
            ),
          ),
        ),
      
    );
  }
}


