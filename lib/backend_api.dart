import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frapods/podcast_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';



const String api_domain = "http://192.168.0.105/Backend/";
//const String api_domain = "https://podcast-api.kleysley.com/Backend/";

class BackendApi {

  final String CURRENT_TOKEN_KEY = "currentToken";
  final String DEVICE_TOKEN_KEY = "currentToken";
  final String NEXT_TOKEN_KEY = "currentToken";
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
        _saveString(USERNAME_KEY, username);
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
              "auth failed, followingn tokens: " +
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
        listOfAllSearchResults.add(PodcastInfo(videos[i]["title"], "", videos[i]["channel"] + " (YouTube)", "GETURL: " + videos[i]["id"], api_domain + "getJpegFile.php?file=" + videos[i]["thumb"]));
      }

    }

    return listOfAllSearchResults;

  }

  Future<List<PodcastInfo>> searchOnFrapods(String query, {int maxNum=10}) async {
    List<PodcastInfo> listOfResults = [];

    var response = await http.get(Uri.parse(api_domain + "search.php?s=" + query));
    String results = response.body;

    if(results != "") {

      final podcasts = json.decode(results);

      podcasts.forEach((podcast) => {
        listOfResults.add(PodcastInfo(podcast["title"], "", podcast["creator_name"] + " (Frapods)", api_domain + "MP3Stream.php?file_id=" + podcast["id"].toString(), ""))
      });

    }

    return listOfResults;
  }


  Future<String> getUrlFromYtID(String id) async {
    log("geturlid is " + id);
    String url = (await http.get(Uri.parse(api_domain +
        "getVideoURL.php?id=$id"))).body;
    log("url is: " + url);
    return url;
  }




  void _saveString(String key, String value) async{
    log("saving string " + value);
    (await SharedPreferences.getInstance()).setString(key, value);
  }

  _getString(String key) async {
    return (await SharedPreferences.getInstance()).getString(key);
  }

}
