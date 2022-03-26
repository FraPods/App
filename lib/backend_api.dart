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
        _saveString("username", username)
        _registerDevice(username, password);
        break;
      case 422:
      case 400:
        log("ERROR!!! Backend code 422 or 400 in createaccount");
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
        break;
      case 422:
      case 400:
        log("ERROR!!! Backend code 422 or 400 in registerdevice");
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
