import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String api_domain = "http://10.0.2.2:8000/";

class BackendApi {

  void createAccount(String username, String password,
      String firstname, String lastname, String email) async {
    log("RESPONSE IS STARTING ");

    var response = await http.get(Uri.parse(api_domain +
        "createAccount.php?username=$username&pwd=$password&firstname=$firstname&lastname=$lastname&email=$email"));
    log("RESPONSE IS THE FOLLOWING " + response.statusCode.toString());

    switch(response.statusCode){
      case 200:
      case 201:
        _saveString("username", username);
        _registerDevice(username, password);
        break;
      case 422:
      case 400:
        log("ERROR!!! Backend code " + response.statusCode.toString() + " in createaccount");
        break;
      case 404:
      case 523:
        log("Servers are down!");
        break;

    }

  }


  void _authenticate(String username, String deviceToken, String nextSessionToken) async {
    var response = await http.get(Uri.parse(api_domain +
        "authenticate.php?username=$username&deviceToken=$deviceToken&sessionToken=$nextSessionToken"));
    switch(response.statusCode){
      case 200:
      case 201:
        _saveString("currentToken", nextSessionToken);
        _saveString("nextToken", utf8.decode(response.bodyBytes));
        log("SUCCESSFUL ACCOUNT CREATION AND LOGIN");
        break;
      case 400:
      case 422:
        log("ERROR!!! Backend code " + response.statusCode.toString() + " in authenticate");
        log(username + ", " + deviceToken + " " + nextSessionToken);
        break;
      case 404:
      case 523:
        log("Servers are down");
        break;


    }

  }


  void _registerDevice(String username, String password) async {
    var response = await http.get(Uri.parse(api_domain +
        "registerDevice.php?username=$username&pwd=$password"));

    switch(response.statusCode){
      case 200:
      case 201:
        String token = utf8.decode(response.bodyBytes);
        _saveString("deviceToken", token);
        _saveString("currentToken", token);
        _saveString("nextToken", token);
        _authenticate(username, token, token);
        break;
      case 422:
      case 400:
        log("ERROR!!! Backend code 422 or 400 in registerdevice");
        break;
      case 523:
        log("Servers are down");
        break;

    }

  }

  void _saveString(String key, String value) async{
    (await SharedPreferences.getInstance()).setString(key, value);
  }

  _getString(String key) async {
    return (await SharedPreferences.getInstance()).getString(key);
  }

}
