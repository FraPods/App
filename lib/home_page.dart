import 'package:flutter/material.dart';
import 'package:frapods/main.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.setPage}) : super(key: key);

  final Function(int index) setPage;

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // declare variables here:


  List<PodcastInfo> listOfAllSearchResults = [];
  Widget logo = Image.asset(
    'assets/icon-round.png',
    fit: BoxFit.fitHeight,
    height: 40,
  );

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              widget.setPage(4);
            },
          )
        ],
        title: Row(
          children: [
            logo,
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("FraPods"),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),

      //End of Title Bar Layout ^^


    );
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
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // This is the widget of one search result entry.
  Widget podcastItem(
      BuildContext ctxt, int index, PodcastInfo podcastInfo ) {
    return TextButton(
      onPressed: () {


        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            PodcastDetailsPage(podcastInfo: podcastInfo);
            return PodcastDetailsPage(podcastInfo: podcastInfo);
          }),
        );
      },
      child: Text(podcastInfo.title),
    );
  }
}
