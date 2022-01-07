import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';
import 'package:frapods/title_changed_notification.dart';


class PodcastDetailsPage extends StatefulWidget {

  const PodcastDetailsPage({Key? key, required this.podcastInfo})
      : super(key: key);

  //following parameters MUST be passed:
  final PodcastInfo podcastInfo;
  @override
  State<PodcastDetailsPage> createState() {
    return _PodcastDetailsPageState();
  }
}


class _PodcastDetailsPageState extends State<PodcastDetailsPage> {
  // declare variables here:


  @override
  Widget build(BuildContext context) {


    playPodcast(url: widget.podcastInfo.url);




    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Title: " + widget.podcastInfo.title),
              Text("Description: " + widget.podcastInfo.description),
              Text("Made by: " + widget.podcastInfo.artist),
              TextButton(
                  onPressed: () {assetsAudioPlayer.playOrPause();},
                  child: Text("Play/Pause")
              )
              

            ],
          ),
        ),
      ),
    );
  }
}


