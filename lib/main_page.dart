import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:frapods/backend_api.dart';
import 'package:frapods/home_page.dart';
import 'package:frapods/podcast_details_page.dart';
import 'package:frapods/setting_page.dart';
import 'package:frapods/upload_page.dart';
import 'main.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';
import 'package:frapods/profile_page.dart';
import 'package:frapods/search_page.dart';
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

  int _selectedIndex = 0;
  int _navbarIndex = 0;
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

    return ValueListenableBuilder<PodcastInfo>(
        valueListenable: currentPodcastInfoNotifier,
        builder: (BuildContext context, PodcastInfo currentPodcastInfo,
            Widget? child) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                key: bottomnavKey,
                backgroundColor:
                blueish(),
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
                  // BottomNavigationBarItem(
                  //   backgroundColor: blueish(),
                  //   icon: Icon(Icons.cloud_upload),
                  //   label: 'Upload',
                  // ),
                  BottomNavigationBarItem(
                    backgroundColor: blueish(),
                    icon: Icon(Icons.account_circle),
                    label: 'Account',
                  ),
                ],
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                currentIndex:
                _selectedIndex <= 2 ? _selectedIndex : _navbarIndex,
                //New
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                    _navbarIndex = index;
                  });
                }),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      HomePage(
                        setPage: setPage,
                      ),
                      SearchPage(),
                      ProfilePage(
                       setPage: setPage,
                      ),
                      UploadPage(
                        setPage: setPage,
                      ),
                      SettingPage(setPage: setPage),
                    ],
                  ),
                ),
                Visibility(
                  visible: !(currentPodcastInfo.title == "NONE" &&
                      currentPodcastInfo.artist == "NONE"),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15, right: 10, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(15),
                          left: Radius.circular(15)),
                      color: Theme
                          .of(context)
                          .colorScheme
                          .background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(4, 7),
                        ),
                      ],
                    ),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        log("Layout clicked");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            PodcastDetailsPage(
                                podcastInfo: currentPodcastInfo);
                            return PodcastDetailsPage(
                                podcastInfo: currentPodcastInfo);
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
                                podcastPlayer.pause();
                              } else {
                                setState(() {
                                  _isPlaying = true;
                                });
                                podcastPlayer.resume();
                              }
                            },
                          ),
                          Flexible(
                            flex: 70,
                            child: Container(
                              padding: EdgeInsets.only(right: 17),
                              child: Text(
                                currentPodcastInfo.title + " by " +
                                    currentPodcastInfo.artist,
                                maxLines: 1,
                                style: normalTextStyle(),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // to calculate sizes
            //floatingActionButton: FloatingActionButton(onPressed:_getSize),
          );
        });
  }


  setPage(int index) {
    if (index == -1) {
      setState(() {
        _selectedIndex = _navbarIndex;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  stream() {
    StreamSubscription teaplayPauseSubscription =
    podcastPlayer.audioPlayer.playingStream.listen((bool isPl) {
      setState(() {
        _isPlaying = isPl;
      });
    });
  }
}
