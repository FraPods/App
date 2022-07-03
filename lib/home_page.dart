import 'dart:developer';
import 'dart:ui';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';
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

  List<PodcastInfo> newestPodcasts = [];
  List<PodcastInfo> newestPodcastsFromFavs = [];
  List<PodcastInfo> randomPodcasts = [];
  List<PodcastInfo> recommendedPodcasts = [];

  List<PodcastInfo> listOfAllSearchResults = [];
  Widget logo = Image.asset(
    'assets/icon-round.png',
    fit: BoxFit.fitHeight,
    height: 40,
  );

  bool firstRender = true;

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;
    double pageWidth = MediaQuery.of(context).size.width;

    if(firstRender) {
      firstRender = false;
      var newParser = BackendApi().getNewestUploads().then((value) => { setState(() => newestPodcasts = value )});
      var newFromFavsParser = BackendApi().newUploadsFromFavorites().then((value) => { setState(() => newestPodcastsFromFavs = value )});
      var randomParser = BackendApi().getRandomPodcasts().then((value) => { setState(() => randomPodcasts = value )});
      var recommendedParser = BackendApi().getRecommendedPodcasts().then((value) => { setState(() => recommendedPodcasts = value )});
    }

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
      body: Container(
        height: pageHeight,
        child: ListView(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height:180,
                  width: pageWidth,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      //const SizedBox(width: 5,),
                      _buildbigCard(15, 'Emma Vanderboom', 'A Podcast about STARS!'),
                      const SizedBox(width: 5,),
                      _buildbigCard(10, 'artclass_57', '\"What is modern art?\" - A serious discussion and analysis'),
                      const SizedBox(width: 5,),
                      _buildbigCard(24, 'ceteruinam', 'Shoes. Shoes? Shoes!'),
                      //const SizedBox(width: 5,),
                    ],
                  ),
                ),
                const SizedBox(height:25),
                const Text('Recommended',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height:10),
                Container(
                  height:135,
                  width: pageWidth,
                  child:ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTempSmallCard(8, 20),
                      _buildTempSmallCard(2, 13),
                      _buildTempSmallCard(35, 2),
                      _buildTempSmallCard(4, 23),
                      _buildTempSmallCard(30, 4)
                    ],
                  )
                ),
                const SizedBox(height:25),
                const Text('What might interest you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height:10),
                Container(
                  height:155,
                  width: pageWidth,
                    child:ListView(
                        scrollDirection: Axis.horizontal,
                        children: recommendedPodcasts.map((e) => _buildSmallCard(e)).toList()
                    )
                ),
                const SizedBox(height:25),
                const Text('Newest uploads',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height:10),
                Container(
                    height:155,
                    width: pageWidth,
                    child:ListView(
                      scrollDirection: Axis.horizontal,
                      children: newestPodcasts.map((e) => _buildSmallCard(e)).toList()
                    )
                ),
                const SizedBox(height:25),
                const Text('New from your Favorites',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height:10),
                Container(
                    height:155,
                    width: pageWidth,
                    child:ListView(
                        scrollDirection: Axis.horizontal,
                        children: newestPodcastsFromFavs.map((e) => _buildSmallCard(e)).toList()
                    )
                ),
                const SizedBox(height:25),
                const Text('Something else',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height:10),
                Container(
                    height:155,
                    width: pageWidth,
                    child:ListView(
                      scrollDirection: Axis.horizontal,
                        children: randomPodcasts.map((e) => _buildSmallCard(e)).toList()
                    )
                ),
              ],
            ),
            )
          ],
        ),
      ),

    );
  }

  Widget _buildbigCard (int thumbnail, String artist, String title){
    return Container(
        width:  MediaQuery.of(context).size.width - 50,
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              Container(
                  height: 135,
                  width: 135,
                  margin: const EdgeInsets.only(left: 15, right: 10),
                  child: Image.asset(
                      'assets/testpodcast' + thumbnail.toString() + '.png')),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height:20),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    width: MediaQuery.of(context).size.width - 250,
                    child: Text(
                      title,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 19),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                    width: MediaQuery.of(context).size.width - 250,
                    child: Text(
                      artist,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildTempSmallCard (int numb, int thumbnail){
    return Container(
      child:Card(
        margin: EdgeInsets.only(right:15),
        color: Colors.transparent,
          elevation: 0,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/testpodcast' + thumbnail.toString() + '.png',
                  height:100, width: 100,),
              ),
              const SizedBox(height:10),
              Text(
                ' podcast'+numb.toString(),
                style: const TextStyle(fontSize: 17),
              )
           ],
          )
      )
    );

  }

  Widget _buildSmallCard (PodcastInfo podcastInfo){
    return InkWell(
      onTap: () async {
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
      child: Container(
        width: 110,
        child:Card(
          margin: const EdgeInsets.only(right:15),
          color: Colors.transparent,
          elevation: 0,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  podcastInfo.thumbnail,
                  height:100, width: 100,),
              ),
              const SizedBox(height:10),
              Container(
                width: 90,
                child: Text(
                  podcastInfo.title,
                  style: const TextStyle(fontSize: 17),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                )
              )
            ],
          ),
        )
      ),
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
