import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';



const String api_domain = "http://10.0.2.2:8000/";

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
        _saveString(CURRENT_TOKEN_KEY, nextSessionToken);
        _saveString(NEXT_TOKEN_KEY, utf8.decode(response.bodyBytes));
        log("SUCCESSFUL ACCOUNT CREATION AND LOGIN, saved following tokens: " + await _getString(CURRENT_TOKEN_KEY) + ", " + await _getString(NEXT_TOKEN_KEY) + ", " + await _getString(DEVICE_TOKEN_KEY));
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
        _saveString(DEVICE_TOKEN_KEY, token);
        _saveString(CURRENT_TOKEN_KEY, token);
        _saveString(NEXT_TOKEN_KEY, token);
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

  void _saveString(String key, String value) async{
    log("saving string " + value);
    (await SharedPreferences.getInstance()).setString(key, value);
  }

  _getString(String key) async {
    return (await SharedPreferences.getInstance()).getString(key);
  }

}
