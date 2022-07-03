import 'package:flutter/services.dart';
import 'package:frapods/podcast_info.dart';
import 'main.dart';

class PlaylistData {
  String name = "";
  List<PodcastInfo> podcasts = [];
  String description = "";
  String thumbnail = "";
  int id = 0;
  bool shuffle = false;
  int currentIndex = 0;

  PlaylistData(String _name, List<PodcastInfo> _podcasts, String _description, String _thumbnail, int _id){
    name = _name;
    podcasts = _podcasts;
    description = _description;
    thumbnail = _thumbnail;
    id = _id;
    //savePlaylistToDevice(this);
  }

  void addSinglePodcast(PodcastInfo podcastInfo){
    podcasts.add(podcastInfo);
    savePlaylistToDevice(this);
  }

  void insertSinglePodcast(PodcastInfo podcastInfo, int index){
    podcasts.insert(index, podcastInfo);
    savePlaylistToDevice(this);
  }

  void addMultiplePodcasts(List<PodcastInfo> podcastsToAdd){
    podcasts.addAll(podcastsToAdd);
    savePlaylistToDevice(this);
  }

  void insertMultiplePodcasts(List<PodcastInfo> podcastsToAdd, int index){
    podcasts.insertAll(index, podcastsToAdd);
    savePlaylistToDevice(this);
  }

  void clearSongs(){
    podcasts.clear();
    currentIndex = 0;
  }

  PodcastInfo getNextSong(){
    if(shuffle){
      PodcastInfo nextPodcast = (podcasts.toList()..shuffle()).first;  // Copy the songs list, randomize its order and get the first element
      currentPodcastInfoNotifier.value = nextPodcast;
      return nextPodcast;
    } else {
      PodcastInfo nextPodcast;
      if(currentIndex > 0 && currentIndex < podcasts.length) {
        nextPodcast = podcasts[currentIndex];
      } else {
        currentIndex = 0; // Playlist is finished, start from beginning
        nextPodcast = podcasts[currentIndex];
      }
      currentIndex++;
      currentPodcastInfoNotifier.value = nextPodcast;
      return nextPodcast;

    }

  }

}











