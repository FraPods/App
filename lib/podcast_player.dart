import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:frapods/main.dart';
import 'package:frapods/podcast_info.dart';


class PodcastPlayer {


  List<PodcastInfo> _songQueue = [];
  int _currentQueueIndex = 0;
  AudioPlayer audioPlayer = AudioPlayer(playerId: "my_unique_id");
  var _songCompleteListener;


  PodcastPlayer() {
    log("Starting listenening in podcastplayer");
    audioPlayer.onDurationChanged.listen((Duration duration) {
      songDurationNotifier.value = duration;
      log("updated seekbar status");
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) {
      songProgressNotifier.value = position;
      log("updated progress status to " + position.toString());
    });
  }

  // Public functions :

  void playPodcast(PodcastInfo podcastInfo) async {
    audioPlayer.stop();
    log("playpodcast called");
    _songQueue.insert(_currentQueueIndex, podcastInfo);
    currentPodcasatInfoNotifier.value = podcastInfo;
    int result = await audioPlayer.play(_songQueue[_currentQueueIndex].url);
    _songCompleteListener = audioPlayer.onPlayerCompletion.listen((event) {
      _songCompleted();
    });
    if (result != 1) {
      playPodcast(podcastInfo);
    }
  }

  void addSongToQueue(PodcastInfo podcastInfo) {
    _songQueue.add(podcastInfo);
  }

  void pause(){
    audioPlayer.pause();
  }

  void resume() {
    audioPlayer.resume();
  }

  void seek(Duration duration){
    audioPlayer.seek(duration);
    audioPlayer.resume();
  }





  // Private interal stuff:

  Duration currentSongLength = Duration(seconds: 0);
  Duration currentSongProgress = Duration(seconds: 0);

  void _songCompleted() async {
    log("song completed");
    _currentQueueIndex++;
    if (_currentQueueIndex == _songQueue.length) {
      //TODO: We are out of songs in the queue
    } else {
      audioPlayer.play(_songQueue[_currentQueueIndex].url);
      currentPodcasatInfoNotifier.value = _songQueue[_currentQueueIndex];
      _songCompleteListener = audioPlayer.onPlayerCompletion.listen((event) {
        _songCompleted();
      });
    }
  }




}