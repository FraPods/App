import 'dart:async';
import 'dart:developer';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:frapods/main.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';

import 'duration_state.dart';

class PodcastDetailsPage extends StatefulWidget {
  const PodcastDetailsPage({Key? key, required this.podcastInfo})
      : super(key: key);

  //following parameters MUST be passed:
  final PodcastInfo podcastInfo;

  @override
  State<PodcastDetailsPage> createState() {
    return _PodcastDetailsPageState();
  }
}

class _PodcastDetailsPageState extends State<PodcastDetailsPage> {
  // declare variables here:
  bool _isPlaying = podcastPlayer.audioPlayer.playing;
  Duration songDuration = songDurationNotifier.value;
  Duration progressDuration = songProgressNotifier.value;
  PodcastInfo currentlyPlayingPodcastInfo = PodcastInfo("", "", "", "", "");

  @override
  Widget build(BuildContext context) {
    currentlyPlayingPodcastInfo = widget.podcastInfo;
    stream();
    songDurationNotifier.addListener(() {
      if(mounted) {
        setState(() {
          songDuration = songDurationNotifier.value;
        });
      }
    });
    songProgressNotifier.addListener(() {
      if(mounted) {
        setState(() {
          progressDuration = songProgressNotifier.value;
        });
      }
    });

    return ValueListenableBuilder<PodcastInfo>(
        valueListenable: currentPodcasatInfoNotifier,
        builder: (BuildContext context, PodcastInfo currentPodcastInfo,
            Widget? child) {
          return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
          child: Center(
            child:
            Column(
              children: <Widget>[
                ColumnSuper (
                  alignment: Alignment.bottomCenter,
                  innerDistance: -23.0,
                  children: <Widget> [
                    ShaderMask(shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(Rect.fromLTRB(0, rect.height / 3, rect.width, rect.height));
                    },
                        blendMode: BlendMode.dstIn,
                        child: Image.network(currentPodcastInfo.thumbnail)
                    ),
                    Text(
                      currentPodcastInfo.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]
                ),
                const SizedBox(height: 5),
                Text(
                  "By " + currentPodcastInfo.artist,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Description: " + currentPodcastInfo.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                ProgressBar(
                  progress: progressDuration,
                  total: songDuration,
                  onSeek: (duration) {
                    podcastPlayer.seek(duration);
                  },
                ),

                IconButton(
                  onPressed: () {
                    if (!podcastPlayer.audioPlayer.playing) {
                      podcastPlayer.audioPlayer.play();
                    } else {
                      podcastPlayer.audioPlayer.pause();
                    }
                  },
                  icon: _isPlaying ? Icon(Icons.pause) : Icon(
                      Icons.play_arrow),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  stream() {
    StreamSubscription teaplayPauseSubscription =
    podcastPlayer.audioPlayer.playingStream.listen((bool isPl) {
      if (mounted) {
        setState(() {
          _isPlaying = isPl;
        });
      }
    });
  }
  }
