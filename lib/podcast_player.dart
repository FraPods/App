import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'main.dart';
final assetsAudioPlayer = AssetsAudioPlayer();


void playPodcast({required String url}) async{
  try{
    await assetsAudioPlayer.open(
        Audio.network(url),
        autoStart: true,
        showNotification: true,
        notificationSettings: const NotificationSettings(
        seekBarEnabled: true,

    )
    );
  }catch(t){
   //TODO: ERROR HANDLING
  }
}

