import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/favorite_db.dart';
import '../now_playing/now_playing.dart';
import '../widget/music_store.dart';

class HomeLiked extends StatefulWidget {
  const HomeLiked({super.key});

  @override
  State<HomeLiked> createState() => _HomeLikedState();
}

class _HomeLikedState extends State<HomeLiked> {
  static List<SongModel> homefavor = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    initialize();
    super.initState();
    setState(() {});
  }

  Future initialize() async {
    await FavoriteDB.favoriteSongs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: FutureBuilder(
          builder: (context, items) {
            return ValueListenableBuilder(
              valueListenable: FavoriteDB.favoriteSongs,
              builder: (context, List<SongModel> favorData, Widget? child) {
                if (favorData.isEmpty) {
                  return Lottie.asset('assets/images/fav.json',
                      height: 80, width: 80);
                } else {
                  final temp = favorData.reversed.toList();
                  homefavor = temp.toSet().toList();
                  return FutureBuilder<List<SongModel>>(
                    future: _audioQuery.querySongs(
                      sortType: SongSortType.TITLE,
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
                        return Center(
                            child: Lottie.asset('assets/images/fav.json',
                                height: 80, width: 80));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount:
                            homefavor.length > 10 ? 10 : homefavor.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.026,
                              top: MediaQuery.of(context).size.width * 0.012,
                              right: MediaQuery.of(context).size.width * 0.026,
                              bottom: MediaQuery.of(context).size.width * 0.006,
                            ),
                            child: InkWell(
                              onTap: () {
                                //List<SongModel> hnewlist = [...homefavor];
                                MusicStore.player.setAudioSource(
                                    MusicStore.createSongList(homefavor),
                                    initialIndex: index);
                                // MusicStore.player.stop();
                                MusicStore.player.play();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlaying(
                                        playerSong: MusicStore.playingSong),
                                  ),
                                );
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.17,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade800
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.020,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      QueryArtworkWidget(
                                        artworkQuality: FilterQuality.high,
                                        size: 2000,
                                        artworkFit: BoxFit.fill,
                                        artworkBorder:
                                            BorderRadius.circular(12.0),
                                        id: homefavor[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image(
                                            image: const AssetImage(
                                                'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              homefavor[index].title,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              homefavor[index].album.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          MusicStore.player.setAudioSource(
                                              MusicStore.createSongList(
                                                  homefavor),
                                              initialIndex: index);
                                          // MusicStore.player.stop();
                                          MusicStore.player.play();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NowPlaying(
                                                  playerSong:
                                                      MusicStore.playingSong),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.play_circle),
                                        color: Colors.white,
                                        iconSize: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // child: ListTile(
                            //   onTap: () {
                            // //List<SongModel> hnewlist = [...homefavor];
                            // MusicStore.player.setAudioSource(
                            //     MusicStore.createSongList(homefavor),
                            //     initialIndex: index);
                            // // MusicStore.player.stop();
                            // MusicStore.player.play();

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => NowPlaying(
                            //         playerSong: MusicStore.playingSong),
                            //   ),
                            // );
                            //   },
                            // leading: QueryArtworkWidget(
                            //   artworkFit: BoxFit.fill,
                            //   id: homefavor[index].id,
                            //   type: ArtworkType.AUDIO,
                            //   nullArtworkWidget: Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.16,
                            //     width:
                            //         MediaQuery.of(context).size.width * 0.35,
                            //     decoration: BoxDecoration(
                            //       gradient: const LinearGradient(
                            //         colors: [
                            //           Colors.blueGrey,
                            //           Colors.white,
                            //           Colors.black
                            //         ],
                            //         begin: Alignment.topLeft,
                            //         end: Alignment.bottomRight,
                            //       ),
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     child: Icon(
                            //       Icons.music_note_rounded,
                            //       color: Colors.blueGrey[600],
                            //     ),
                            //   ),
                            //     artworkBorder: const BorderRadius.all(
                            //       Radius.circular(
                            //         10,
                            //       ),
                            //     ),
                            //     artworkWidth:
                            //         MediaQuery.of(context).size.width * 0.34,
                            //     artworkHeight:
                            //         MediaQuery.of(context).size.height * 0.16,
                            //   ),
                            //   title: Center(
                            // child: Text(
                            //   homefavor[index].title,
                            //   overflow: TextOverflow.clip,
                            //   softWrap: false,
                            //   style: const TextStyle(fontSize: 16),
                            // ),
                            //   ),
                            // ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
