import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/playlist_db.dart';
import '../../model/music_player.dart';

class SongsList extends StatefulWidget {
  const SongsList({super.key, required this.playList});
  final MusicPlayer playList;

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800,
            Colors.deepPurple.shade200,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            'Add Songs',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<List<SongModel>>(
            future: audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item) {
              if (item.data == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Songs Found',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    iconColor: const Color.fromARGB(255, 255, 255, 255),
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(
                            'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                      ),
                      artworkFit: BoxFit.fill,
                      artworkQuality: FilterQuality.high,
                      size: 2000,
                      artworkBorder:
                          const BorderRadius.all(Radius.circular(30)),
                    ),
                    title: Text(
                      item.data![index].displayNameWOExt,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "${item.data![index].artist}",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    trailing: !widget.playList.isValueIn(item.data![index].id)
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                playlistCheck(item.data![index]);
                                PlaylistDB.playlistNotifier.notifyListeners();
                              });
                            },
                            icon: const Icon(Icons.add),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                widget.playList
                                    .deleteData(item.data![index].id);
                              });
                              const snackBar = SnackBar(
                                backgroundColor: Colors.deepPurpleAccent,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Song removed from playlist',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(milliseconds: 600),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: const Icon(Icons.playlist_add_check),
                          ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const Divider();
                },
                itemCount: item.data!.length,
              );
            },
          ),
        ),
      ),
    );
  }

  void playlistCheck(SongModel data) {
    if (!widget.playList.isValueIn(data.id)) {
      widget.playList.add(data.id);
      const snackbar = SnackBar(
          backgroundColor: Colors.deepPurpleAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 600),
          content: Text(
            'song Added to Playlist',
            style: TextStyle(
              color: Colors.white,
            ),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
