import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key,required this.username, required this.notifyParent})
      : super(key: key);

  //following parameters MUST be passed:
  final Function(PodcastInfo podcastInfo, bool musicMenuVisible) notifyParent;
  final String username;


  @override
  State<SearchPage> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {

  // declare variables here:
  int _selectedIndex = 0;
  bool _isSearchBarOpened = false;
  List<PodcastInfo> listOfAllSearchResults = [];
  Icon searchBarIcon = Icon(Icons.search);
  Widget searchBar = Image.asset(
    'assets/icon-round.png',
    fit: BoxFit.fitHeight,
    height: 40,
  );

  @override
  Widget build(BuildContext context) {

    _isSearchBarOpened = true;
    searchBar = ListTile(
      leading: const Icon(
        Icons.search,
        color: Colors.white,
        size: 28,
      ),
      title: TextField(
        onSubmitted: (String text) {
          sendSearchRequest(text);
        },
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'Search for Podcasts',
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: searchBar,
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
                    podcastItem(ctxt, index, listOfAllSearchResults, widget),
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

      listOfAllSearchResults.add(PodcastInfo("Result1Title", "This is the Podcast result 1", "artist1", "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3"));
      listOfAllSearchResults.add(PodcastInfo("Result2Title", "This is the Podcast result 2", "artist2", "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3"));
      listOfAllSearchResults.add(PodcastInfo("Result3Title", "This is the Podcast result 3", "artist3", "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3"));


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
  Widget podcastItem(BuildContext ctxt, int index, List<PodcastInfo> listofresults, SearchPage parentWidget) {
    return TextButton(
      onPressed: () {

        PodcastInfo podcastInfo = PodcastInfo(listofresults[index].title, listofresults[index].description, listofresults[index].artist, listofresults[index].url);
        parentWidget.notifyParent(podcastInfo, true);
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
