import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:frapods/main.dart';
import 'package:frapods/podcast_info.dart';


class PodcastPlayer {
  AudioPlayer audioPlayer = AudioPlayer();
  var songFinishedListener;




  PodcastPlayer() {
    songFinishedListener = null;
    songFinishedListener = audioPlayer.processingStateStream.listen((ProcessingState processingState) {
      if(processingState == ProcessingState.completed){
        log("STATE IS COMPLETED");
        _play(listOfAllPlaylists[currentPlaylistInList].getNextSong());
      }
    });


    log("Starting listenening in podcastplayer");
    audioPlayer.durationStream.listen((Duration? duration) {
      if(duration != null){
        songDurationNotifier.value = duration;
      }
    });
    audioPlayer.positionStream.listen((Duration position) {
      songProgressNotifier.value = position;
    });
  }

  void _play(PodcastInfo podcastInfo) async {
    audioPlayer.stop();
    audioPlayer.setUrl(podcastInfo.url);
    audioPlayer.play();
  }

  // Public functions :

  void playPodcast(PodcastInfo podcastInfo) async {
    int currentIndex = listOfAllPlaylists[currentPlaylistInList].currentIndex;
    listOfAllPlaylists[currentPlaylistInList].insertSinglePodcast(podcastInfo, currentIndex);
    _play(listOfAllPlaylists[currentPlaylistInList].getNextSong());
  }

  void addSongToQueue(PodcastInfo podcastInfo) {
    listOfAllPlaylists[0].addSinglePodcast(podcastInfo);
  }

  void pause(){
    audioPlayer.pause();
  }

  void resume() {
    audioPlayer.play();
  }

  void seek(Duration duration){
    audioPlayer.seek(duration);
    audioPlayer.play();
  }





  // Private interal stuff:

  Duration currentSongLength = Duration(seconds: 0);
  Duration currentSongProgress = Duration(seconds: 0);





}