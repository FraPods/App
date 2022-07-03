import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:frapods/backend_api.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:frapods/main.dart';
import 'package:frapods/podcast_info.dart';
import 'package:just_audio_background/just_audio_background.dart';


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
    log("PLAY FUNCTION");
    int totalDuration = songDurationNotifier.value.inMilliseconds;
    bool wasPlaying = audioPlayer.playing;
    await audioPlayer.stop();
    int lastStartTime = songStartTime;
    log(wasPlaying.toString());
    if(!wasPlaying) {
      lastStartTime = DateTime.now().millisecondsSinceEpoch - timeSincePause;
    } else {
      lastStartTime -= timeSincePause;
    }
    timeSincePause = 0;
    int currentPodcastId = currentSongId;
    songStartTime = DateTime.now().millisecondsSinceEpoch;
    currentSongId = podcastInfo.id;
    log(lastStartTime.toString() + " / " + totalDuration.toString() + " / " + currentPodcastId.toString() + " / " + timeSincePause.toString());
    if(currentPodcastId > 0) {
      createRating(lastStartTime, totalDuration, currentPodcastId);
    }
    await audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(podcastInfo.url),
      tag: MediaItem(
          id: "1",
          title: podcastInfo.title,
          artist: podcastInfo.artist,
          displayDescription: podcastInfo.description,
      ),
    ));
    await audioPlayer.play();
  }

  void createRating(int startTime, int duration, int id) async {
    double timeRating = ((songStartTime - startTime) / duration) * 3.1;
    log(timeRating.toString());
    if(timeRating > 3.0) timeRating = 3.0;
    BackendApi().submitRating(id, timeRating);
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
    log("PAUSE");
    timeSincePause += DateTime.now().millisecondsSinceEpoch - songStartTime;
    songStartTime = DateTime.now().millisecondsSinceEpoch;
    audioPlayer.pause();
  }

  void resume() {
    songStartTime = DateTime.now().millisecondsSinceEpoch;
    audioPlayer.play();
  }

  void seek(Duration duration){
    audioPlayer.seek(duration);
    audioPlayer.play();
  }

  void dispose() {
    audioPlayer.dispose();
  }

  // Private interal stuff:

  Duration currentSongLength = Duration(seconds: 0);
  Duration currentSongProgress = Duration(seconds: 0);

  int songStartTime = DateTime.now().millisecondsSinceEpoch;
  int currentSongId = 0;
  int timeSincePause = 0;

}