import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';


class InfoMusic {
  String ? trackName;
  List<String>? trackArtistNames ;
  Uint8List? albumArt ;
  String? authorName ;
  String? writerName ;
  int ? trackDuration;
  String ? fileMusic;

  InfoMusic(
      {this.trackName,
      this.trackArtistNames,
      this.albumArt,
      this.authorName,
      this.trackDuration,
      this.fileMusic,
      this.writerName});

  InfoMusic.fromMeta(Metadata metaData){
    trackName = metaData.trackName;
    trackArtistNames = metaData.trackArtistNames;
    albumArt = metaData.albumArt;
    authorName = metaData.albumName;
    writerName = metaData.writerName;
    trackDuration = metaData.trackDuration;
    fileMusic = metaData.filePath;
  }
}