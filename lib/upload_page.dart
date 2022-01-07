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
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text("This is the upload page"),
        ),
      ),
    );
  }
}


