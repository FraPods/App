import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frapods/playlist_info.dart';
import 'package:frapods/podcast_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

const String api_domain = "http://192.168.0.105/Backend/";
//const String api_domain = "https://podcast-api.kleysley.com/Backend/";

class BackendApi {

  final String CURRENT_TOKEN_KEY = "currenttoken";
  final String DEVICE_TOKEN_KEY = "devicetoken";
  final String NEXT_TOKEN_KEY = "nexttoken";
  final String USERNAME_KEY = "username";
  bool isLoggedIn = false;

  Future<String> createAccount(String username, String password,
      String firstname, String lastname, String email) async {
    log("RESPONSE IS STARTING ");

    var response = await http.get(Uri.parse(api_domain +
        "createAccount.php?username=$username&pwd=$password&firstname=$firstname&lastname=$lastname&email=$email"));
    log("RESPONSE IS THE FOLLOWING " + response.body);

    switch(response.statusCode){
      case 200:
      case 201:
        return "200";
        break;
      case 422:
      case 400:
        log("ERROR!!! Backend code " + response.statusCode.toString() + " in createaccount");
        return "400";
        break;
      case 404:
      case 523:
        log("Servers are down!");
        return "523";
        break;
    }
    return "";

  }

  Future<String> _authenticate(String username, String deviceToken, String nextSessionToken) async {
    log("authenticate called");
    var response = await http.get(Uri.parse(api_domain +
        "authenticate.php?username=$username&deviceToken=$deviceToken&sessionToken=$nextSessionToken"));
    switch(response.statusCode){
      case 200:
      case 201:
        if(nextSessionToken != "error" && utf8.decode(response.bodyBytes) != "error") {
          _saveString(CURRENT_TOKEN_KEY, nextSessionToken);
          _saveString(NEXT_TOKEN_KEY, utf8.decode(response.bodyBytes));
          log(
              "SUCCESSFUL ACCOUNT CREATION AND LOGIN, saved following tokens: " +
                  await _getString(CURRENT_TOKEN_KEY) + ", " +
                  await _getString(NEXT_TOKEN_KEY) + ", " +
                  await _getString(DEVICE_TOKEN_KEY));
          log("login notifier value changed by backendapi");
          loginNotifier.value = true;
        } else {
          log(
              "auth failed, following tokens: " +
                  await _getString(CURRENT_TOKEN_KEY) + ", " +
                  await _getString(NEXT_TOKEN_KEY) + ", " +
                  await _getString(DEVICE_TOKEN_KEY));
        }
        return "200";
        break;
      case 400:
      case 422:
        log("ERROR!!! Backend code " + response.statusCode.toString() + " in authenticate");
        log(username + ", " + deviceToken + " " + nextSessionToken);
        return "400";
        break;
      case 404:
      case 523:
        log("Servers are down");
        return "523";
        break;


    }
    return "";

  }

  Future<String> autoLogIn() async {
    if(isLoggedIn){
      return "200";
    }
    log("autologin called");
    isLoggedIn = true;
    String username = await _getString(USERNAME_KEY);
    String deviceToken = await _getString(DEVICE_TOKEN_KEY);
    String sessionToken = await _getString(NEXT_TOKEN_KEY);
    log(username);
    log(deviceToken);
    log(sessionToken);
    var response = await _authenticate(username, deviceToken, sessionToken);
    log("response:autologin: " + response);
    if(await _getString(DEVICE_TOKEN_KEY) != "error") {
      return response;
    } else {
      return "400";
    }
  }


  Future<String> logIn(String username, String password) async {
    var response = await http.get(Uri.parse(api_domain +
        "registerDevice.php?username=$username&pwd=$password"));

    switch(response.statusCode){
      case 200:
      case 201:
        log(response.body);
        String token = response.body;
        if(token != "error") {
          _saveString(USERNAME_KEY, username);
          _saveString(DEVICE_TOKEN_KEY, token);
          _saveString(CURRENT_TOKEN_KEY, token);
          _saveString(NEXT_TOKEN_KEY, token);
        }

        log(( await http.get(Uri.parse(api_domain +
            "verifyDevice.php?deviceToken=$token&sessionToken=$token"))).statusCode.toString());
        return "200";
        break;
      case 422:
      case 400:
        log("ERROR!!! Backend code 422 or 400 in registerdevice");
        return "400";
        break;
      case 523:
        log("Servers are down");
        return "523";
        break;

    }
    return "";
  }


  Future<List<PodcastInfo>> searchOnYoutube(String query, {int maxNum=10}) async{
    if(maxNum > 10){ maxNum = 10; }
    List<PodcastInfo> listOfAllSearchResults = [];

    // Gets the first 10 search results from youtube
    var response = await http.get(Uri.parse(api_domain +
        "extractYoutubeResults.php?search=$query"));
    String results = response.body;
    int statusCode = response.statusCode;
    if(statusCode == 200){

      final videos = jsonDecode(results);

      for(int i = 0; i < videos.length; i++) {
        listOfAllSearchResults.add(PodcastInfo(videos[i]["title"], "", videos[i]["channel"] + " (YouTube)", "GETURL: " + videos[i]["id"], api_domain + "getJpegFile.php?file=" + videos[i]["thumb"], 0));
      }

    }

    return listOfAllSearchResults;

  }

  Future<List<PodcastInfo>> searchOnFrapods(String query, {int maxNum=10}) async {
    List<PodcastInfo> listOfResults = [];

    var response = await http.get(Uri.parse(api_domain + "search.php?s=" + query + "&username=" + await _getString(USERNAME_KEY) + "&deviceToken=" + await _getString(DEVICE_TOKEN_KEY) + "&sessionToken=" + await _getString(CURRENT_TOKEN_KEY)));
    String results = response.body;

    if(results != "") {

      final podcasts = json.decode(results);

      podcasts.forEach((podcast) => {
        listOfResults.add(PodcastInfo(podcast["title"], "", podcast["creator_name"] + " (Frapods)", api_domain + "MP3Stream.php?file_id=" + podcast["id"].toString(), api_domain + "getImage.php?size=512&bw=0&circle=0&file_id=" + podcast["thumbnail"].toString(), podcast["id"]))
      });

    }

    return listOfResults;
  }

  Future<List<PodcastInfo>> getPodcastsFrom(String username, bool self, bool sleep, {int maxNum=10}) async {
    if(sleep) await Future.delayed(const Duration(milliseconds: 100));
    List<PodcastInfo> listOfResults = [];

    if(self) username = await _getString(USERNAME_KEY);

    var response = await http.get(Uri.parse(api_domain + "getFromUser.php?susername=" + username + "&username=" + await _getString(USERNAME_KEY) + "&deviceToken=" + await _getString(DEVICE_TOKEN_KEY) + "&sessionToken=" + await _getString(CURRENT_TOKEN_KEY)));
    String results = response.body;

    if(results != "") {
      final podcasts = json.decode(results);
      podcasts.forEach((podcast) => {
        listOfResults.add(PodcastInfo(podcast["title"], "", podcast["creator_name"], "", api_domain + "getImage.php?size=512&bw=0&circle=0&file_id=" + podcast["thumbnail"].toString(), podcast["id"]))
      });
    }

    return listOfResults;
  }


  Future<PodcastInfo> getPodcastData(int id, {int maxNum=10}) async {
    PodcastInfo result = PodcastInfo("", "", "", "", "", 0);

    var response = await http.get(Uri.parse(api_domain + "getPodcastDetails.php?id=" + id.toString() + "&username=" + await _getString(USERNAME_KEY) + "&deviceToken=" + await _getString(DEVICE_TOKEN_KEY) + "&sessionToken=" + await _getString(CURRENT_TOKEN_KEY)));
    String results = response.body;

    if(results != "") {

      final podcast = json.decode(results);
      //result = PodcastInfo(podcast["title"], "", podcast["creator_name"], api_domain + "MP3Stream.php?file_id=" + podcast["id"].toString(), api_domain + "getImage.php?size=512&bw=0&circle=0&file_id=" + podcast["thumbnail"].toString(), podcast["id"]);
      result = PodcastInfo(podcast["title"], podcast["description"], podcast["creator_name"], "url", api_domain + "getImage.php?size=512&bw=0&circle=0&file_id=" + podcast["thumbnail"].toString(), podcast[id]);
    }

    return result;
  }

  Future<void> editPodcastData(PodcastInfo newData) async {
    var thumbnail = newData.thumbnail;
    if(int.parse(thumbnail) == null) {
      thumbnail = Uri.parse(thumbnail).queryParameters['file_id'] ?? "4";
    }
    http.get(Uri.parse(api_domain + "editPodcastDetails.php?id=" + newData.id.toString() + "&title=" + newData.title + "&description=" + newData.description + "&creator=" + newData.artist + "&lyrics=abc&year=2022&thumbnail_id=" + thumbnail));
    return;
  }

  Future<int> uploadPodcast(Uint8List? file) async {
    var map = Map<String, dynamic>();
    map['data'] = file.toString();
    map['username'] = await _getString(USERNAME_KEY);
    map['sessionToken'] = await _getString(CURRENT_TOKEN_KEY);
    map['deviceToken'] = await _getString(DEVICE_TOKEN_KEY);
    var response = await http.post(
      Uri.parse(api_domain + 'upload.php?mp3=mp3'),
      body: map,
    );
    return int.parse(response.body);
  }

  Future<int> uploadThumbnail(Future<Uint8List> file) async {
    var map = Map<String, dynamic>();
    map['data'] = (await file).toString();
    map['username'] = await _getString(USERNAME_KEY);
    map['sessionToken'] = await _getString(CURRENT_TOKEN_KEY);
    map['deviceToken'] = await _getString(DEVICE_TOKEN_KEY);
    var response = await http.post(
      Uri.parse(api_domain + 'upload.php?thumbnail=thumbnail'),
      body: map,
    );
    return int.parse(response.body);
    return 0;
  }

  /*Future<int> uploadThumbnail(File file) async {
    log("Uploading Thumbnail...");

    var request = http.MultipartRequest('POST', Uri.parse(api_domain + "upload.php?thumbnail=thumbnail"));
    request.fields['username'] = await _getString(USERNAME_KEY);
    request.fields['sessionToken'] = await _getString(CURRENT_TOKEN_KEY);
    request.fields['deviceToken'] = await _getString(DEVICE_TOKEN_KEY);
    request.files.add(
      http.MultipartFile(
        'picture',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: "uploadThumbnail.png"
      )
    );
    /*var res = await request.send();
    var responseId = int.parse(await res.stream.bytesToString());
    log(responseId.toString());
    return responseId;*/
    return 0;
  }*/

  Future<String> getUrlFromYtID(String id) async {
    String url = (await http.get(Uri.parse(api_domain + "getVideoURL.php?id=$id"))).body;
    return url;
  }

  Future<dynamic> getAccountData(String username, bool self) async {
    if(self) username = await _getString(USERNAME_KEY);
    String result = (await http.get(Uri.parse(api_domain + "getAccountData.php?username=$username"))).body;
    final jsonData = json.decode(result);
    log(jsonData["username"]);
    return jsonData;
  }

  Future<List<PlaylistData>> getOwnPlaylists() async {
    List<PlaylistData> playlists = [];
    String textualResult = (await http.get(Uri.parse(api_domain + "getUserPlaylists.php?username=" + (await _getString(USERNAME_KEY))))).body;
    final jsonData = json.decode(textualResult);
    jsonData.forEach((jsonPlaylist) => {
      playlists.add(PlaylistData(jsonPlaylist["title"], []))
    });
    return playlists;
  }

  void _saveString(String key, String value) async {
    log("saving string " + value);
    (await SharedPreferences.getInstance()).setString(key, value);
  }

  _getString(String key) async {
    return (await SharedPreferences.getInstance()).getString(key);
  }

}
