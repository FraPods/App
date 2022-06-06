
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/main.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'podcast_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  //following parameters MUST be passed:

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
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: listOfAllSearchResults.length,
                itemBuilder: (BuildContext ctxt, int index) => podcastItem(
                    ctxt,
                    index,
                    PodcastInfo(
                      listOfAllSearchResults[index].title,
                      listOfAllSearchResults[index].description,
                      listOfAllSearchResults[index].artist,
                      listOfAllSearchResults[index].url,
                      listOfAllSearchResults[index].thumbnail
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendSearchRequest(String text) async {
    // TODO: Write search request to server function

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      }
    );

    List<PodcastInfo> frapodsResults = [];
    List<PodcastInfo> youtubeResults = [];

    if(isFrapodsSourceActivated) {
       frapodsResults = await BackendApi().searchOnFrapods(text);
    }

    if(isYoutubeSourceActivated) {
      youtubeResults = await BackendApi().searchOnYoutube(text);
    }

    Navigator.of(context).pop();

    setState(() {
      listOfAllSearchResults.addAll(frapodsResults);
      listOfAllSearchResults.addAll(youtubeResults);
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
  Widget podcastItem(BuildContext ctxt, int index, PodcastInfo podcastInfo) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
          onPressed: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }
            );

            if (podcastInfo.url.startsWith("GETURL")) {
              String url = await BackendApi()
                  .getUrlFromYtID(podcastInfo.url.substring(8));
              podcastPlayer.playPodcast(PodcastInfo(podcastInfo.title,
                  podcastInfo.description, podcastInfo.artist, url, podcastInfo.thumbnail));
            } else {
              podcastPlayer.playPodcast(podcastInfo);
            }

            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                PodcastDetailsPage(podcastInfo: podcastInfo);
                return PodcastDetailsPage(podcastInfo: podcastInfo);
              }),
            );
          },
          onLongPress: () async {
            showDialogMessage("Adding song to queue",
                "This is an experimental feature. You are adding a song to the queue. ");

            if (podcastInfo.url.startsWith("GETURL")) {
              String url = await BackendApi()
                  .getUrlFromYtID(podcastInfo.url.substring(8));
              podcastPlayer.addSongToQueue(PodcastInfo(podcastInfo.title,
                  podcastInfo.description, podcastInfo.artist, url, podcastInfo.thumbnail));
            } else {
              podcastPlayer.addSongToQueue(podcastInfo);
            }
          },
          child: Container(
            width: double.maxFinite,
            child: Card(
              elevation: 0,
              color: Color(0x00000000),
              //Theme.of(context).colorScheme.primaryVariant,
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Image.network(podcastInfo.thumbnail),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                        width: MediaQuery.of(context).size.width - 130,
                        child: Text(
                          podcastInfo.title,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 8, 0, 5),
                        width: MediaQuery.of(context).size.width - 130,
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
            child: const Divider(
              thickness: 1,
              color: Colors.grey,
            ))
      ],
    );
  }
}
