import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
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
    await audioPlayer.stop();
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

  void dispose() {
    audioPlayer.dispose();
  }

  // Private interal stuff:

  Duration currentSongLength = Duration(seconds: 0);
  Duration currentSongProgress = Duration(seconds: 0);





}