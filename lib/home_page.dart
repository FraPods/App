import 'package:flutter/material.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/profile_page.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,required this.username})
      : super(key: key);

  //following parameters MUST be passed:
  final String username;

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // declare variables here:
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
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (searchBarIcon.icon == Icons.search) {
                    _isSearchBarOpened = true;
                    searchBarIcon = const Icon(Icons.cancel);
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
                  } else {
                    _isSearchBarOpened = false;
                    searchBarIcon = const Icon(Icons.search);
                    searchBar = Image.asset(
                      'assets/icon-round.png',
                      fit: BoxFit.fitHeight,
                      height: 40,
                    );
                  }
                });
              },
              icon: searchBarIcon),
          Visibility(
            visible: !_isSearchBarOpened,
            child: IconButton(

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {ProfilePage(title: "FraPods", username: "username"); return ProfilePage(title: "FraPods", username: "username");}
                ),
                );
              },
              icon: Icon(Icons.account_circle),
          ),
          ),
        ],
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
