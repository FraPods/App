import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:open_file/open_file.dart';
import 'package:image_picker/image_picker.dart';

import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/playlist_info.dart';
import 'package:frapods/podcast_player.dart';
import 'add_new_podcast.dart';

class AddNewPlaylist extends StatefulWidget {
  //AddNewPlaylist({Key? key}) : super(key: key);
  final Function newPlaylist;
  final int id;

  AddNewPlaylist(this.newPlaylist, this.id);

  @override
  State<AddNewPlaylist> createState() {
    return _AddNewPlaylistState();
  }
}

class _AddNewPlaylistState extends State<AddNewPlaylist> {
  // declare variables here:

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;

    return FractionallySizedBox(
      heightFactor: 0.6,
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
                    onTap:(){},
                    child: const Icon(Icons.edit)
                  )
              ],),
            ),
            Center(child: Text(
              'data',
              style: const TextStyle(fontSize: 22)),),
            const SizedBox(height:5),
            Container(
              height:pageHeight*0.57,
              child: Text('dad')
              // widget.playlistData.podcasts.isEmpty? 
              // Text('No podcasts in this playlist yet......'):
              // ListView.builder(
              //   itemCount: widget.playlistData.podcasts.length,
              //   itemBuilder: (ctx, index) => playlistPodcast(widget.playlistData.podcasts[index]),
              // )
            )
          ],
        ),
      )
    );
  }

  Widget playlistPodcast (PodcastInfo pc){
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
                      Container(
                        height: 60,
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: pc.thumbnail.isEmpty?Image.asset('assets/test_podcast_thumbnail.jpg'):
                        Image.network(pc.thumbnail),
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
        Divider(
          thickness: 1,
          color: Colors.grey,
        )
      ],
    );
  }
}