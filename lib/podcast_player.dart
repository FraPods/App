import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:frapods/podcast_info.dart';

List<PodcastInfo> _songQueue = [];
int _currentQueueIndex = 0;
AudioPlayer audioPlayer = AudioPlayer(playerId: "my_unique_id");
var _songCompleteListener;

void addSongToQueue(PodcastInfo podcastInfo) {
  _songQueue.add(podcastInfo);
}

void songCompleted() async {
  log("song completed");
  _currentQueueIndex++;
  if (_currentQueueIndex == _songQueue.length) {
    //TODO: We are out of songs in the queue
  } else {
    audioPlayer.play(_songQueue[_currentQueueIndex].url);
    _songCompleteListener = audioPlayer.onPlayerCompletion.listen((event) {
      songCompleted();
    });
  }
}

void playPodcast(PodcastInfo podcastInfo) async {
  audioPlayer.stop();
  log("playpodcast called");
  _songQueue.insert(_currentQueueIndex, podcastInfo);
  int result = await audioPlayer.play(_songQueue[_currentQueueIndex].url);
  _songCompleteListener = audioPlayer.onPlayerCompletion.listen((event) {
    songCompleted();
  });
  if (result != 1) {
    //TODO: Error handling
  }
}
