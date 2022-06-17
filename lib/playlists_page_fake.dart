import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';
import 'package:open_file/open_file.dart';

import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/playlist_info.dart';
import 'package:frapods/podcast_player.dart';

import 'dart:math';

class PlaylistsPagefake extends StatefulWidget {
  PlaylistsPagefake({Key? key}) : super(key: key);

  @override
  State<PlaylistsPagefake> createState() {
    return _PlaylistsPagefakeState();
  }
}

class _PlaylistsPagefakeState extends State<PlaylistsPagefake> {
  // declare variables here:

  @override
  Widget build(BuildContext context) {
    //define variables here
    double pageHeight = MediaQuery.of(context).size.height - 56;

    return FractionallySizedBox(
        heightFactor: 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close)),
                    InkWell(onTap: () {}, child: const Icon(Icons.edit))
                  ],
                ),
              ),
              const Center(
                child: Text('playlist 1', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(height: 10),
              Container(
                  height: pageHeight * 0.57,
                  child: ListView(
                    children: [
                      _buildPod(1, 5),
                      _buildPod(2, 3),
                      _buildPod(3, 10),
                      _buildPod(4, 9),
                      _buildPod(5, 1),
                      _buildPod(6, 2),
                      _buildPod(7, 8),
                    ],
                  ))
            ],
          ),
        ));
  }

  Widget _buildPod(int numb, int thumbnail) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          child: Card(
            elevation: 0,
            color: const Color(0x00000000),
            child: Row(
              children: [
                Container(
                    height: 60,
                    width: 60,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Image.asset(
                        'assets/testpodcast' + thumbnail.toString() + '.png')),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      width: MediaQuery.of(context).size.width - 140,
                      child: Text(
                        'podcast' + numb.toString(),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 8, 0, 5),
                      width: MediaQuery.of(context).size.width - 140,
                      child: Text(
                        'artist' + numb.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
