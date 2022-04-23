import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/main.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/profile_page.dart';
import 'podcast_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key,required this.notifyParent})
      : super(key: key);

  //following parameters MUST be passed:
  final Function(PodcastInfo podcastInfo, bool musicMenuVisible) notifyParent;


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
        cursorColor: Colors.white,
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
            SizedBox(height:10),
            Expanded(
              child: ListView.builder(
                itemCount: listOfAllSearchResults.length,
                itemBuilder: (BuildContext ctxt, int index) =>
                    podcastItem(ctxt, index, new PodcastInfo(listOfAllSearchResults[index].title, listOfAllSearchResults[index].description, listOfAllSearchResults[index].artist, listOfAllSearchResults[index].url,)),
              ),
            ),



          ],
        ),
      ),


    );
  }

  Future<void> sendSearchRequest(String text) async {
    // TODO: Write search request to server function
    List<PodcastInfo> youtubeResults = await BackendApi().searchOnYoutube(text);
    setState(() {
      listOfAllSearchResults = youtubeResults;
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
  Widget podcastItem(
      BuildContext ctxt, int index, PodcastInfo podcastInfo ) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(padding:EdgeInsets.fromLTRB(5,0,5,0)),
          onPressed: () async {
            if(podcastInfo.url.startsWith("GETURL")){
              playPodcast(url:  await BackendApi().getUrlFromYtID(podcastInfo.url.substring(8)));
            } else {
              playPodcast(url: podcastInfo.url);
            }
            widget.notifyParent(podcastInfo, true);
        
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                PodcastDetailsPage(podcastInfo: podcastInfo);
                return PodcastDetailsPage(podcastInfo: podcastInfo);
              }),
            );
          },
          child: Container(
            width: double.maxFinite,
            child: Card(
              elevation: 0,
              color: Color(0x00000000), //Theme.of(context).colorScheme.primaryVariant,
              child: Row(
                children: [
                  Container(
                  height:50,
                   width: 50,
                   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                   decoration: BoxDecoration(border: Border.all(color:Colors.pink, width:2)),
                   ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 5,10, 0),
                        width: MediaQuery.of(context).size.width -120,
                        child: Text(
                          podcastInfo.title,
                          maxLines:2,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,softWrap: false,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 8, 0, 5),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              podcastInfo.artist,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.92,
          child: Divider(thickness: 1,color: Colors.grey,))
      ],
    );
  }
}
