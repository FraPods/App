
import 'package:flutter/material.dart';
import 'package:frapods/podcast_info.dart';

class PodcastChangedNotification extends Notification {
  final PodcastInfo podcastInfo;

  const PodcastChangedNotification(this.podcastInfo);
}