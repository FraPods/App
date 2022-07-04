import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class PodcastInfo{
  String _title = "";
  String _description = "";
  String _artist = "";
  String _url = "";
  String _thumbnail = "";
  int _id = 0;
  String _yt_id = "";

  String get title {
    return _title;
  }

  String get description {
    return _description;
  }

  String get artist {
    return _artist;
  }

  String get url {
    return _url;
  }

  String get thumbnail {
    return _thumbnail;
  }

  int get id {
    return _id;
  }

  String get yt_id {
    return _yt_id;
  }

  set title (String nTitle) {
    _title = nTitle;
  }

  set artist (String nArtist) {
    _artist = nArtist;
  }

  set description (String nDescription) {
    _description = nDescription;
  }

  set thumbnail (String nThumbnail) {
    _thumbnail = nThumbnail;
  }

  set id (int nId) {
    _id = nId;
  }

  set yt_id (String nYt_id) {
    _yt_id = nYt_id;
  }

  PodcastInfo();

  PodcastInfo.create(String ctitle, String cdescription, String cartist, String curl, String cthumbnail, int cid, String cyt_id) {
    _title = ctitle;
    _description = cdescription;
    _artist = cartist;
    _url = curl;
    _thumbnail = cthumbnail;
    _id = cid;
    _yt_id = cyt_id;
  }

  bool get empty {
    return (_title == "" && _description == "" && _artist == "" && _url == "" && _thumbnail == "" && _id == 0 && _yt_id == "");
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
    return PodcastInfo.create(json['title'] as String, json['description'] as String, json['artist'] as String, json['url'] as String, json['thumbnail'] as String, json['id'] as int, json['yt_id'] as String);
  }
}


