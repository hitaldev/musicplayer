import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player/info_music.dart';
import 'package:music_player/music_details.dart';
import 'package:music_player/util.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicList extends StatefulWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  final FileManagerController controller = FileManagerController();
  Future<PermissionStatus> permission() async {
    var res = await Permission.storage.request();
    return res;
  }
  bool isLoad = false;
  List<InfoMusic> _songs = [];

  Future<void> getMusic() async {
    Directory dir = Directory('/storage/emulated/0/');
    String mp3Path = dir.toString();
    List<FileSystemEntity> _files;
    _files = dir.listSync(recursive: true, followLinks: false);
    Future.forEach(_files, (FileSystemEntity element) async {
      String path = element.path;
      if (path.endsWith('.mp3')) {
        await MetadataRetriever.fromFile(File(path)).then((value) {
          _songs.add(InfoMusic.fromMeta(value));
        });
      }
    }).then((value) {
      print(_songs);
      setState(() {
        isLoad = true;
      });
    });
  }


  @override
  void initState() {
    permission().then((value) {
      getMusic();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build (BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF2F312E),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              color: Color(0xFF20221F),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text("My Music",
                      style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Expanded(
              child: !isLoad ? Center(child: CircularProgressIndicator(color: Colors.yellow,)) : Padding(
                padding: const EdgeInsets.all(10),
                child: FileManager(
                  controller: controller,
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: _songs.where((element) => element.authorName!=null || element.trackName!=null).length,
                      itemBuilder: (context, index) {
                        var list = _songs.where((element) => element.authorName!=null || element.trackName!=null).toList();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return MusicDetails(infoMusic: list[index]);
                              },
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: randomColor(),
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(color: Colors.white,width: 1)
                                      ),
                                      child: list[index].albumArt==null ?
                                      Container()
                                          :ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.memory(
                                            list[index].albumArt!),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(child: Text(list[index].trackName??list[index].authorName??"",
                                    style: TextStyle(color: Colors.white),)),
                                    SizedBox(width: 10,),
                                    Text(formatDuration(Duration(milliseconds: list[index].trackDuration!)),
                                    style: TextStyle(color: Colors.yellow)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

