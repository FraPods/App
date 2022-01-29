import 'package:flutter/material.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/setting_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.setPage})
      : super(key: key);


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
    return Scaffold(
       appBar: AppBar(
         actions: [
           IconButton(icon: Icon(Icons.settings),
            onPressed: () {
              widget.setPage(4);
            },)
         ],
          title: Row(children: [
            logo,
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("FraPods"),
            )
          ],
          ),
        automaticallyImplyLeading: false,

        ),

      //End of Title Bar Layout ^^

      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: listOfAllSearchResults.length,
                itemBuilder: (BuildContext ctxt, int index) =>
                    podcastItem(ctxt, index, listOfAllSearchResults),
              ),
            ),
            

            
          ],
        ),
      ),



    );
  }

  void sendSearchRequest(String text) {
    // TODO: Write search request to server function



    setState(() {
      listOfAllSearchResults = [];

      listOfAllSearchResults.add(PodcastInfo("Result1", "This is the Podcast result 1", "artist 1", "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3"));
      listOfAllSearchResults.add(PodcastInfo("Result2", "This is the Podcast result 2", "artist 2", "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3"));
      listOfAllSearchResults.add(PodcastInfo("Result3", "This is the Podcast result 3", "artist 3", "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3"));


    });
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

  // This is the widget of one search result entry.
  Widget podcastItem(BuildContext ctxt, int index, List<PodcastInfo> listofresults) {
    return TextButton(
      onPressed: () {

        PodcastInfo podcastInfo = PodcastInfo(listofresults[index].title, listofresults[index].description, listofresults[index].artist, listofresults[index].url);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {PodcastDetailsPage(podcastInfo: listofresults[index]); return PodcastDetailsPage(podcastInfo: listofresults[index]);}
          ),
        );
      },
      child: Text(listofresults[index].title),
    );
  }
}