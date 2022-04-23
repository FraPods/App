import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:frapods/main.dart';
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





    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Column(
          children: <Widget>[
            Text(widget.podcastInfo.title,
            style:TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            ),
            SizedBox(height:5),
            Text("By "+widget.podcastInfo.artist,
            style: TextStyle(
              fontSize: 20, 
            ),),
            SizedBox(height:15),
            Text("Description: " + widget.podcastInfo.description,
            style: TextStyle(
              fontSize: 16, 
            ),),
            Spacer(),
            IconButton(
                onPressed: () {assetsAudioPlayer.playOrPause();},
                icon: Icon(Icons.pause)
            )
            

          ],
        ),
      ),
    );
  }
}


