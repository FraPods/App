import 'package:flutter/material.dart';
import 'package:frapods/add_new_playlist.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/main.dart';

import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/playlist_info.dart';

import 'dart:math';

class PlaylistsPage extends StatefulWidget {
  //PlaylistsPage({Key? key}) : super(key: key);
  final PlaylistData playlistData;

  PlaylistsPage(this.playlistData);

  @override
  State<PlaylistsPage> createState() {
    return _PlaylistsPageState();
  }
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  // declare variables here:

  int rn1 = Random().nextInt(24);

  PlaylistData playlistData = PlaylistData("", [], "", "", 0);
  bool firstLoad = true;
  bool contentLoaded = false;
  
  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;

    if(firstLoad) {
      firstLoad = false;
      playlistData = widget.playlistData;
      BackendApi().getPlaylistData(widget.playlistData.id.toString()).then((value) => {
        contentLoaded = true,
        setState(() => { playlistData = value })
      });
    }

    return FractionallySizedBox(
      heightFactor: 0.7,
      child:Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(onTap:() => Navigator.of(context).pop(),
                  child: const Icon(Icons.close)),
                  InkWell(
                    onTap:(){
                      showModalBottomSheet(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          context: context,
                          builder: (_){
                            return AddNewPlaylist(() {}, playlistData.id, () { Navigator.of(context).pop(); Navigator.of(context).pop(); });
                          },
                          isScrollControlled: true
                      );
                    },
                    child: const Icon(Icons.edit)
                  )
              ],),
            ),
            Center(child: Text(
              playlistData.name,
              style: const TextStyle(fontSize: 22)),),
            const SizedBox(height:5),
            SizedBox(
              height: contentLoaded ? pageHeight*0.57 : 80,
              width: contentLoaded ? double.maxFinite : 40,
              child: contentLoaded ?
              (playlistData.podcasts.isEmpty?
              const Text('No podcasts in this playlist yet......'):
              ListView.builder(
                itemCount: playlistData.podcasts.length,
                itemBuilder: (ctx, index) => playlistPodcast(playlistData.podcasts[index], index, playlistData.id),
              )) : Column(children: const [
                SizedBox(height: 40,),
                CircularProgressIndicator(strokeWidth: 2, )
              ],
              )
            )
          ],
        ),
      )
    );
  }

  Widget playlistPodcast (PodcastInfo pc, int index, int playlistId){
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: const [
                Icon(Icons.delete, size: 18),
                Text(" Löschen", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
          key: Key(pc.thumbnail),
          onDismissed: (direction) {
            setState(() {
              playlistData.podcasts.removeAt(index);
              BackendApi().removeFromPlaylist(playlistId.toString(), pc.id == 0 ? pc.yt_id : pc.id.toString());
            });
          },
          child: InkWell(
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

              if (pc.url.startsWith("GETURL")) {
                String url = await BackendApi()
                    .getUrlFromYtID(pc.url.substring(8));
                podcastPlayer.playPodcast(PodcastInfo.create(
                    pc.title, pc.description, pc.artist, url, pc.thumbnail, pc.id, pc.yt_id));
              } else {
                podcastPlayer.playPodcast(pc);
              }

              Navigator.of(context).pop();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  PodcastDetailsPage(podcastInfo: pc);
                  return PodcastDetailsPage(podcastInfo: pc);
                }),
              );
            },
            child: SizedBox(
              width: double.maxFinite,
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
                      child: pc.thumbnail.isEmpty ? Image.asset('assets/testpodcast' + rn1.toString() + '.png'):
                      Image.network(pc.thumbnail, fit: BoxFit.cover,),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          width: MediaQuery.of(context).size.width - 140,
                          child: Text(
                            pc.title,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 8, 0, 5),
                          width: MediaQuery.of(context).size.width - 140,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              pc.artist,
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
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        )
      ],
    );
  }
}