import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String api_domain = "http://192.168.178.213/Backend/";

class BackendApi {

  Future<String> createAccount(String username, String password, String firstname, String lastname, String email) async {
    final response = await http.get(Uri.parse(api_domain + "createAccount.php?username=$username&pwd=$password&firstname=$firstname&lastname=$lastname&email=$email"));
    log("RESPONSE IS THE FOLLOWING " + utf8.decode(response.bodyBytes));
    return utf8.decode(response.bodyBytes);

  }


}