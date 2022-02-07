import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';



class UploadPage extends StatefulWidget {

  const UploadPage({Key? key})
      : super(key: key);


  @override
  State<UploadPage> createState() {
    return _UploadPageState();
  }
}


class _UploadPageState extends State<UploadPage> {
  // declare variables here:


  @override
  Widget build(BuildContext context) {

    //define variables here


    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon-round.png',
          fit: BoxFit.fitHeight,
          height: 40,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        child: 
        Column(
          children: <Widget> [

            Center(
              child: Container(
                width: double.maxFinite,
                height: 70,
                child: TextButton(
                  onPressed: null, 
                  child: Text('new podcast'),
                  style: textButtonStyle(),
                  ),
              ),
            ),

            // End of first Button

            Center(
              child: Container(
                width: double.maxFinite,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical:20),
                        child: 
                        Center(
                          child: Text('Add new Episode to existing podcast', style: TextStyle(fontSize: 17),),
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}


ButtonStyle textButtonStyle () {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color> (Color(0xFF1D71E1)),
    textStyle: MaterialStateProperty.all <TextStyle>(
      TextStyle (
        color: Colors.white,
        fontSize: 23
      )
    )
  );
}
