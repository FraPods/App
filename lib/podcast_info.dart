import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class PodcastInfo{
  String title = "";
  String description = "";
  String artist = "";
  String url = "";
  String thumbnail = "";
  //PlatformFile file;

  PodcastInfo(String title, String description, String artist, String url, String thumbnail){
    this.title = title;
    this.description = description;
    this.artist = artist;
    this.url = url;
    this.thumbnail = thumbnail;
  }


  Map toJson() {
    return {
      'title': title,
      'description': description,
      'artist': artist,
      'url': url,
    };
  }

  factory PodcastInfo.fromJson(dynamic json) {
    return PodcastInfo(json['title'] as String, json['description'] as String, json['artist'] as String, json['url'] as String, json['thumbnail'] as String);
  }

  PodcastInfo.only ({this.title ="",this.description = "", this.artist = "", this.url = "", this.thumbnail = ""});

}


