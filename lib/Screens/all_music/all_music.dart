import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/recent_songs_db.dart';
import '../favorites/favoritebutton.dart';
import '../now_playing/now_playing.dart';
import '../widget/music_store.dart';

class AllMusic extends StatefulWidget {
  const AllMusic({Key? key}) : super(key: key);
  static List<SongModel> song = [];

  @override
  State<AllMusic> createState() => _AllMusicState();
}

class _AllMusicState extends State<AllMusic> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

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
          title: const Text(
            'All Songs',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
              sortType: SongSortType.TITLE,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: ((context, item) {
              if (item.data == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                  child: Text('No Songs Found'),
                );
              }

              return ListView.builder(
                itemCount: item.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                    valueListenable: RecentSongsController.recentsNotifier,
                    builder: (BuildContext context, List<SongModel> recentValue,
                        Widget? child) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.013,
                        ),
                        child: ListTile(
                          leading: QueryArtworkWidget(
                            artworkQuality: FilterQuality.high,
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.fill,
                            nullArtworkWidget: const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                  'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                            ),
                          ),
                          title: Text(
                            item.data![index].title,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            "${item.data![index].artist}  ",
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 13,
                            ),
                          ),
                          trailing: FavoriteBut(song: item.data![index]),
                          onTap: () {
                            MusicStore.player.setAudioSource(
                              MusicStore.createSongList(item.data!),
                              initialIndex: index,
                            );
                            MusicStore.player.play();
                            RecentSongsController.addRecentlyPlayed(
                                item.data![index].id);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NowPlaying(
                                  playerSong: MusicStore.playingSong,
                                  //item.data!,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
