import 'dart:async';
import 'dart:developer';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:frapods/main.dart';
import 'package:frapods/main_page.dart';
import 'package:frapods/podcast_info.dart';
import 'package:frapods/podcast_player.dart';
import 'package:url_launcher/url_launcher.dart';

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
  PodcastInfo currentlyPlayingPodcastInfo = PodcastInfo();

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
        valueListenable: currentPodcastInfoNotifier,
        builder: (BuildContext context, PodcastInfo currentPodcastInfo,
            Widget? child) {
          return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
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
                SizedBox(
                  height: 225,
                  child: Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: RichText(
                            text: TextSpan(
                                text: "Description: \n",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                                //children: <TextSpan>[
                                //  TextSpan(text: currentPodcastInfo.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white))
                                //]
                                children: linkifyRichText(currentPodcastInfo.description)
                            ),
                          ),
                        )
                    ),
                  ],)
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
                      podcastPlayer.resume();
                    } else {
                      podcastPlayer.pause();
                    }
                  },
                  icon: _isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      );
    });
  }

  List<TextSpan> linkifyRichText(String text) {
    List<TextSpan> linkObject = [];
    List<String> textSegments = [];
    //textSegments = text.split(RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'));
    textSegments = text.split(" ");
    for (String element in textSegments) {
      int newLineIndex = element.indexOf("\n");
      if(newLineIndex > 0) {
        String textSubSegment = element.substring(0, newLineIndex);
        if(textSubSegment.contains("http")) {
          linkObject.add(TextSpan(text: " " + textSubSegment, recognizer: TapGestureRecognizer()..onTap = () =>
          {
            launchUrl(Uri.parse(textSubSegment))
          }, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, decoration: TextDecoration.underline)));
        } else {
          linkObject.add(TextSpan(text: " " + textSubSegment, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)));
        }
        element = element.substring(newLineIndex);
      }
      if(element.contains("http")) {
        linkObject.add(TextSpan(text: " " + element, recognizer: TapGestureRecognizer()..onTap = () =>
        {
          launchUrl(Uri.parse(element))
        }, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, decoration: TextDecoration.underline)));
      } else {
        linkObject.add(TextSpan(text: " " + element, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)));
      }
    }
    return linkObject;
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
