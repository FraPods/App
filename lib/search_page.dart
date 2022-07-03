
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/main.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/profile_page.dart';
import 'package:frapods/playlist_info.dart';
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

  void _moreOptions (BuildContext ctx, {int id = 0}) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: ctx,
      builder: (_){
        return FractionallySizedBox(
          heightFactor: 0.3,
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 15,),
                  const Text('More options', style: TextStyle(fontSize: 21, decoration: TextDecoration.underline),),
                  InkWell(child: const Icon(Icons.close, size:25),
                  onTap:()=> Navigator.of(context).pop())
                ],
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: ()=>_addToPlaylist(context),
                child: Row(
                  children: const [
                    Icon(Icons.add_box_rounded, size: 30,),
                    SizedBox(width: 10,),
                    Text('Add to playlist', style: TextStyle(fontSize: 19)),
                  ],
                ),),
                const SizedBox(height:10),
              InkWell(
                onTap: (){},
                child: Row(
                  children: const [
                    Icon(Icons.report_rounded,size: 30),
                    SizedBox(width: 10,),
                    Text('Report', style: TextStyle(fontSize: 19))
                  ],
                ),),
            ],
          ),),
        );
      },
      isScrollControlled: true
      );
  }

  void _addToPlaylist (BuildContext ctx,  {int id = 0}) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: ctx,
      builder: (_){
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add to playlist:', style: TextStyle(fontSize: 21,),),
                  InkWell(child: const Icon(Icons.close, size:25),
                  onTap:()=> Navigator.of(context).pop())
                ],
              ),
              const SizedBox(height:10),
              Container(
              height:(MediaQuery.of(context).size.height - 56)*0.57,
              child: playlists.isEmpty? 
              const Center(child: Text('You don\'t have a playlist yet......')):
              ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (ctx, index) => playlistsList(playlists[index]),
              )
            )
            ],
          )
          )
        );
      },
      isScrollControlled: true
      );
  }

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

      // End of Title Bar Layout ^^

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
                      listOfAllSearchResults[index].thumbnail,
                      listOfAllSearchResults[index].id
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendSearchRequest(String text) async {
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
      listOfAllSearchResults = frapodsResults;
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
        Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(5, 0, 5, 0)),
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
                  podcastPlayer.playPodcast(PodcastInfo(podcastInfo.title, podcastInfo.description, podcastInfo.artist, url, podcastInfo.thumbnail, podcastInfo.id));
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
                  podcastPlayer.addSongToQueue(PodcastInfo(podcastInfo.title, podcastInfo.description, podcastInfo.artist, url, podcastInfo.thumbnail, podcastInfo.id));
                } else {
                  podcastPlayer.addSongToQueue(podcastInfo);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                child: Card(
                  elevation: 0,
                  color: const Color(0x00000000),
                  //Theme.of(context).colorScheme.primaryVariant,
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Image.network(podcastInfo.thumbnail),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            width: MediaQuery.of(context).size.width * .85 - 130,
                            child: Text(
                              podcastInfo.title,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(10, 8, 0, 5),
                            width: MediaQuery.of(context).size.width - 130,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                podcastInfo.artist,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 15),
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
                alignment: Alignment.topRight,
                child: InkWell(
                  child: const Icon(Icons.more_vert_rounded),
                  onTap: ()=> _moreOptions(context),
                )
            ),
          ],
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

  Widget playlistsList (PlaylistData pl){
    return Column(
      children: [
        InkWell(
          onTap:() {
          },
          //onHover: ,
          child: Container(
                width: double.maxFinite,
                child: Card(
                  elevation: 0,
                  color: const Color(0x00000000),
                  //Theme.of(context).colorScheme.primaryVariant,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                            width: MediaQuery.of(context).size.width - 140,
                            child: Text(
                              pl.name,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 19),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        )
      ],
    );
  }
}
