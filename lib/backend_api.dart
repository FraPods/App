import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frapods/podcast_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';



const String api_domain = "https://podcast-api.kleysley.com/Backend/";

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

      for(int i = 0; i < maxNum; i++){
        int idx = results.indexOf("}");
        String currentResult = results.substring(0, idx).trim() + "}";
        results = results.substring(idx+1).trim();

        String title = "";
        String artist = "";
        String url = "";
        String id = "";
        log("currentresult is " + currentResult);
        String startStr = "'id': '";
        String startStrAlternatiave2 = "'id': \""; // It is legit INSANE how much Youtube tries to defeat crawlers, they randomly replace single quotes with double quotes
        String endStr = "',";
        int startIndex = currentResult.indexOf(startStr);
        if(startIndex == -1){
          startIndex = currentResult.indexOf(startStrAlternatiave2);
          endStr = "\",";
        }
        currentResult = currentResult.substring(startIndex);
        int endIndex = currentResult.indexOf(endStr);
        id = currentResult.substring(0 + startStr.length, endIndex);

        log("currentresult is " + currentResult);
        log("id is " + id);
        log("artist is " + artist);
        log("title is " + title);


        startStr = "'title': '";
        startStrAlternatiave2 = "'title': \""; // It is legit INSANE how much Youtube tries to defeat crawlers, they randomly replace single quotes with double quotes
        endStr = "',";
        startIndex = currentResult.indexOf(startStr);
        if(startIndex == -1){
          startIndex = currentResult.indexOf(startStrAlternatiave2);
          endStr = "\",";
        }
        currentResult = currentResult.substring(startIndex);

        endIndex = currentResult.indexOf(endStr);
        title = currentResult.substring(0 + startStr.length, endIndex);

        log("currentresult is " + currentResult);
        log("id is " + id);
        log("artist is " + artist);
        log("title is " + title);


        startStr = "'channel': '";
        startStrAlternatiave2 = "'channel': \""; // It is legit INSANE how much Youtube tries to defeat crawlers, they randomly replace single quotes with double quotes
        endStr = "'}";
        startIndex = currentResult.indexOf(startStr);
        if(startIndex == -1){
          startIndex = currentResult.indexOf(startStrAlternatiave2);
          endStr = "\"}";
        }
        currentResult = currentResult.substring(startIndex);
        endIndex = currentResult.indexOf(endStr);
        artist = currentResult.substring(0 + startStr.length, endIndex);
        log("currentresult is " + currentResult);

        log("id is " + id);
        log("artist is " + artist);
        log("title is " + title);



        listOfAllSearchResults.add(new PodcastInfo(title, "No description available", artist, "GETURL: " + id));

      }

    }

    return listOfAllSearchResults;


  }


  Future<String> getUrlFromYtID(String id) async {
    log("geturlid is " + id);
    String url = (await http.get(Uri.parse(api_domain +
    "extractVideo.php?id=$id"))).body;
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
