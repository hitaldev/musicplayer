import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/info_music.dart';
import 'package:music_player/util.dart';

class MusicDetails extends StatefulWidget {
  final InfoMusic  infoMusic;
  const MusicDetails({Key? key, required this.infoMusic}) : super(key: key);

  @override
  _MusicDetailsState createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails> {
  AudioPlayer player =  AudioPlayer();
  playMusic() async {
    player.play(widget.infoMusic.fileMusic!);
    isPlay = false;
    setState(() {

    });
  }
  bool isPlay = false;
  Duration duration=Duration();
  Duration position=Duration();


  @override
  void initState() {
    playMusic();
    player.onDurationChanged.listen((event) {
      duration = event;
      setState(() {

      });
    });
    player.onAudioPositionChanged.listen((event) {
      position = event;
      setState(() {

      });
    });
    player.onPlayerCompletion.listen((event) {
      playMusic();
    });
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    player.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF2F312E),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                color: Color(0xFF20221F),
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(widget.infoMusic.trackName.toString(),
                        style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width/2,
                height:MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    color: randomColor(),
                    borderRadius: BorderRadius.circular(200),
                    border: Border.all(color: Colors.white,width: 1)
                ),
                child: widget.infoMusic.albumArt==null ? Container() :ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.memory(widget.infoMusic.albumArt!,
                    width: MediaQuery.of(context).size.width/2,height:MediaQuery.of(context).size.width/2,
                    fit: BoxFit.cover,),
                ),
              ),
              Spacer(),
              Slider(
                value: position.inSeconds/duration.inSeconds,
                onChanged: (d){
                  player.seek(Duration(milliseconds:  (d*duration.inMilliseconds).round() ));
                },
                activeColor: Colors.yellow,
                inactiveColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(formatDuration(Duration(seconds: position.inSeconds)),style: TextStyle(
                        fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white
                    ),),
                    Spacer(),
                    Text(formatDuration(Duration(seconds: duration.inSeconds)),style: TextStyle(
                        fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white
                    ),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  isPlay = !isPlay;
                  if(isPlay) {
                    player.pause();
                  } else {
                    player.resume();
                  }
                  setState(() {

                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white,width: 1)
                  ),
                  child: Icon(isPlay ? CupertinoIcons.play_arrow_solid :
                  CupertinoIcons.pause,color: Colors.white,),
                ),
              ),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}

