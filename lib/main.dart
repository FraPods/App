
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frapods/playlist_info.dart';
import 'package:localstorage/localstorage.dart';
// import all class files (create one class per page)
import 'home_page.dart';
import 'login_page.dart';
import 'setting_page.dart';
import 'backend_api.dart';
import 'package:just_audio_background/just_audio_background.dart';



Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const FraPodsApp());
}

// Do not create layouts in this file! (main.dart)
// Each Page should have its own file (eg. "the_page.dart").  No spaces and no capital letters.

class FraPodsApp extends StatelessWidget {

  void init() async {
    BackendApi().autoLogIn();
    loadSettingsFromDevice();
    await loadAllPlaylistsFromDevice();
  }

  const FraPodsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

  init();

    return ValueListenableBuilder<bool>(
        valueListenable: loginNotifier,
        builder: (BuildContext context, bool isLogedIn, Widget? child) {
          return ValueListenableBuilder<bool>(
              valueListenable: darkNotifier,
              builder: (BuildContext context, bool isDark, Widget? child) {
                return MaterialApp(
                    title: 'FraPods',
                    themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                    theme: ThemeData(
                        appBarTheme: AppBarTheme(
                            backgroundColor: blueish(),
                            foregroundColor: Colors.white),
                        //primaryColor: Colors.white,
                        colorScheme: ColorScheme.light(
                          primary: Color(0xff3884E6),
                          primaryContainer: Color(0xFF99C4FD),
                          secondary: Color(0xFF424242),
                          secondaryContainer: Color(0xff646464),
                          surface: Color(0xffFFFDF4),
                          //ebeeee
                          background: Color(0xffcccccc),
                          error: Color(0xffb00020),
                          onPrimary: Colors.black,
                          onSecondary: Colors.black,
                          onSurface: Colors.black,
                          onBackground: Colors.black,
                          onError: Colors.white,
                          brightness: Brightness.light,
                        )),
                    darkTheme: ThemeData(
                        appBarTheme: AppBarTheme(
                            backgroundColor: blueish(),
                            foregroundColor: Colors.white),
                        // primarySwatch: generateMaterialColorFromColor(Color(0xFF004AAD)),
                        // primaryColor: Colors.white,
                        backgroundColor: backgroundColor(),
                        colorScheme: ColorScheme.dark(
                          primary: Color(0xff0264e3),
                          primaryContainer: Color(0xff4889DD),
                          secondary: Color(0xFF646464),
                          secondaryContainer: Color(0xff909090),
                          surface: Color(0xff424242),
                          background: Color(0xff757575),
                          //Colors.grey.shade700,
                          error: Color(0xffcf6679),
                          onPrimary: Colors.white,
                          onSecondary: Colors.black,
                          onSurface: Colors.white,
                          onBackground: Colors.white,
                          onError: Colors.black,
                          brightness: Brightness.dark,
                        )),
                    home: isLogedIn == false
                        ? const LoginPage()
                        : const MainPage());
              });
        });
  }
}

// define public methods here:

TextStyle highlightedTextStyle() {
  return TextStyle(
    fontSize: 16,
    color: generateMaterialColorFromColor(Color(0xFF004AAD)),
  );
}

TextStyle titleTextStyle() {
  return TextStyle(
    fontSize: 32,
    color: generateMaterialColorFromColor(Color(0xFF004AAD)),
    shadows: <Shadow>[
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 1.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 1.0,
        color: Color.fromARGB(125, 0, 0, 255),
      ),
    ],
  );
  ;
}

TextStyle normalTextStyle() {
  return TextStyle(
    fontSize: 16,
    //color: generateMaterialColorFromColor(Color(0xFFFFFFFF)),
  );
}

TextStyle normalTextStyle2() {
  return TextStyle(
    fontSize: 18,
    //color: generateMaterialColorFromColor(Color(0xFFFFFFFF)),
  );
}

TextStyle subtitleTextStyle() {
  return TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    //color: Colors.white,
  );
}

TextStyle shadowTextStyle() {
  return TextStyle(
    fontSize: 18,
    color: generateMaterialColorFromColor(Color(0xFF004AAD)),
    shadows: <Shadow>[
      Shadow(
        offset: Offset(0.5, 0.1),
        blurRadius: 0.5,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      Shadow(
        offset: Offset(0.5, 0.1),
        blurRadius: 0.5,
        color: Color.fromARGB(125, 0, 0, 255),
      ),
    ],
  );
  ;
}

Color blueish() {
  return generateMaterialColorFromColor(Color(0xFF004AAD));
}

Color backgroundColor() {
  return Color(0xFF292929);
}

MaterialColor generateMaterialColorFromColor(Color color) {
  return MaterialColor(color.value, {
    50: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
    100: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
    200: Color.fromRGBO(color.red, color.green, color.blue, 0.3),
    300: Color.fromRGBO(color.red, color.green, color.blue, 0.4),
    400: Color.fromRGBO(color.red, color.green, color.blue, 0.5),
    500: Color.fromRGBO(color.red, color.green, color.blue, 0.6),
    600: Color.fromRGBO(color.red, color.green, color.blue, 0.7),
    700: Color.fromRGBO(color.red, color.green, color.blue, 0.8),
    800: Color.fromRGBO(color.red, color.green, color.blue, 0.9),
    900: Color.fromRGBO(color.red, color.green, color.blue, 1.0),
  });
}



const String DARKMODE_ACTIVATED_KEY = "isDarkModeActivated";
const String YOUTUBE_SOURCE_ACTIVATED_KEY = "isYoutubeSourceActivated";
const String FRAPODS_SOURCE_ACTIVATED_KEY = "isFrapodsSourceActivated";


final darkNotifier = ValueNotifier<bool>(isDarkModeActivated);
var loginNotifier = ValueNotifier<bool>(false);
var currentPodcasatInfoNotifier = ValueNotifier<PodcastInfo>(PodcastInfo("NONE", "NONE", "NONE", "NONE"));
var songDurationNotifier = ValueNotifier<Duration>(Duration(seconds: 0));
var songProgressNotifier = ValueNotifier<Duration>(Duration(seconds: 0));

bool isDarkModeActivated = true;
bool isYoutubeSourceActivated = true;
bool isFrapodsSourceActivated = true;

PodcastPlayer podcastPlayer = new PodcastPlayer();

GlobalKey bottomnavKey = GlobalKey();
Size? bottomnavSize = bottomnavKey.currentContext!.size;


// To calculate sizes
GlobalKey sizeKey = GlobalKey();
Size? size = sizeKey.currentContext!.size;


void saveBool(String key, bool value) async{
  (await SharedPreferences.getInstance()).setBool(key, value);
}

Future<bool> getBool(String key) async {
  bool? fetchedBool = (await SharedPreferences.getInstance()).getBool(key);
  if(fetchedBool != null){
    return fetchedBool;
  } else {
    return true;
  }
}

void loadSettingsFromDevice() async{
  isDarkModeActivated = await getBool(DARKMODE_ACTIVATED_KEY);
  darkNotifier.value = isDarkModeActivated;
  isFrapodsSourceActivated = await getBool(FRAPODS_SOURCE_ACTIVATED_KEY);
  isYoutubeSourceActivated = await getBool(YOUTUBE_SOURCE_ACTIVATED_KEY);
}



final LocalStorage storage = LocalStorage('storage');
List<PlaylistData> listOfAllPlaylists = [PlaylistData("queue", [])];
int currentPlaylistInList = 0;


Future<void> savePlaylistToDevice(PlaylistData playlistData) async {

  if(playlistData.name != "queue") {
    String key = playlistData.name;
    List<PodcastInfo> songList = playlistData.podcasts;
    String jsonStr = jsonEncode(songList);
    await storage.setItem(key, jsonStr);

    // Update playlist register
    var registerString = await storage.getItem("register");
    List<String> registerList = [];
    if (registerString == Null || registerString == null) {
      await storage.setItem("register", jsonEncode([key]));
    } else {
      registerList = List.from(jsonDecode(registerString) as List);

      registerList.add(key);
      await storage.setItem("register", jsonEncode(registerList));
    }
  }

}

Future<void> loadAllPlaylistsFromDevice() async {
  List<String> keys = List.from(jsonDecode(await storage.getItem("register")));
  for(String key in keys){
    List<PodcastInfo> currentPlaylist = (jsonDecode(await storage.getItem(key)) as List).map((podcastInfoJson) => PodcastInfo.fromJson(podcastInfoJson)).toList();
    listOfAllPlaylists.add(PlaylistData(key, currentPlaylist));
  }
}