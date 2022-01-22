import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frapods/home_page.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/upload_page.dart';
import 'main.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';
import 'package:frapods/profile_page.dart';
import 'package:frapods/search_page.dart';
import 'package:frapods/title_changed_notification.dart';
import 'dart:developer';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static _MainPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainPageState>();

  //following parameters MUST be passed:

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  // declare variables here:

  bool _musicControlMenuVisible = false;
  bool _isPlaying = false;

  String currentTitle = "";
  String currentArtist = "";
  String currentDescription = "";
  PodcastInfo currentPodcasatInfo = PodcastInfo("...", "...", "...", "...");

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
    stream();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: generateMaterialColorFromColor(Color(0xffebf7ff)),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: blueish(),
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: blueish(),
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              backgroundColor: blueish(),
              icon: Icon(Icons.cloud_upload),
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              backgroundColor: blueish(),
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          //New
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      body: Column(
        children: <Widget>[
          NotificationListener<PodcastChangedNotification>(
            onNotification: (PodcastChangedNotification notification) {
              setState(() {
                currentTitle = notification.podcastInfo.title;
                currentArtist = notification.podcastInfo.artist;
                currentDescription = notification.podcastInfo.description;
              });
              return true;
            },
            child: Container(),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                HomePage(),
                SearchPage(notifyParent: refresh),
                UploadPage(),
                ProfilePage(),
              ],
            ),
          ),
          Visibility(
            visible: _musicControlMenuVisible,
            child: Container(
                decoration: BoxDecoration(
                    color: generateMaterialColorFromColor(Color(0xffebf7ff)),
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 1),
                      bottom: BorderSide(color: Colors.black, width: 1),
                    )),
                child: Container(
                  color: backgroundColor(),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      log("Layout clicked");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          PodcastDetailsPage(podcastInfo: currentPodcasatInfo);
                          return PodcastDetailsPage(
                              podcastInfo: currentPodcasatInfo);
                        }),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          icon: _isPlaying
                              ? Icon(
                                  Icons.pause,
                                  size: 40.0,
                                )
                              : Icon(Icons.play_arrow, size: 40.0),
                          onPressed: () {
                            if (_isPlaying) {
                              setState(() {
                                _isPlaying = false;
                              });
                              assetsAudioPlayer.pause();
                            } else {
                              setState(() {
                                _isPlaying = true;
                              });
                              assetsAudioPlayer.play();
                            }
                          },
                        ),
                        Text(currentTitle + " by " + currentArtist,
                            style: normalTextStyle()),
                        Spacer(),
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void updatePodcastInfo(PodcastInfo podcastInfo) {
    print("DEBUGPODS method page called");
    setState(() {
      currentTitle = podcastInfo.title;
      currentArtist = podcastInfo.artist;
      currentDescription = podcastInfo.description;
    });
  }

  refresh(PodcastInfo podcastInfo, bool musicMenuVisible) {
    setState(() {
      currentTitle = podcastInfo.title;
      currentArtist = podcastInfo.artist;
      currentDescription = podcastInfo.description;
      currentPodcasatInfo = podcastInfo;
      _musicControlMenuVisible = musicMenuVisible;
    });
  }

  stream() {
    StreamSubscription teaplayPauseSubscription =
        assetsAudioPlayer.isPlaying.listen((p) {
      if (_isPlaying != p) {
        _isPlaying = p;
        setState(() {
          _isPlaying = p;
        });
      }
    });
  }
}
