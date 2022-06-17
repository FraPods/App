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

  int rn1 = Random().nextInt(7);
  int rn2 = Random().nextInt(7);
  int rn3 = Random().nextInt(7);
  int rn4 = Random().nextInt(7);
  int rn5 = Random().nextInt(7);
  int rn6 = Random().nextInt(7);

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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Image.asset('assets/testpodcast' +
                                      rn1.toString() +
                                      '.png')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'podcast 1',
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 8, 0, 5),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'artist 1',
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Image.asset('assets/testpodcast' +
                                      rn2.toString() +
                                      '.png')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'podcast 2',
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 8, 0, 5),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'artist 2',
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Image.asset('assets/testpodcast' +
                                      rn3.toString() +
                                      '.png')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'podcast 3',
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 8, 0, 5),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'artist 3',
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Image.asset('assets/testpodcast' +
                                      rn4.toString() +
                                      '.png')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'podcast 4',
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 8, 0, 5),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'artist 4',
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Image.asset('assets/testpodcast' +
                                      rn5.toString() +
                                      '.png')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'podcast 5',
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 8, 0, 5),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'artist 5',
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Image.asset('assets/testpodcast' +
                                      rn6.toString() +
                                      '.png')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'podcast 6',
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 8, 0, 5),
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    child: const Text(
                                      'artist 6',
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
                    ],
                  ))
            ],
          ),
        ));
  }
}
