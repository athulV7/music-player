import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/favorite_db.dart';
import '../../database/recent_songs_db.dart';
import '../now_playing/now_playing.dart';
import '../widget/music_store.dart';

class HomeRecentsSongs extends StatefulWidget {
  const HomeRecentsSongs({Key? key}) : super(key: key);

  @override
  State<HomeRecentsSongs> createState() => _HomeRecentsSongsState();
}

class _HomeRecentsSongsState extends State<HomeRecentsSongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> removedup = [];
  @override
  void initState() {
    super.initState();
    init();
    setState(() {});
  }

  Future init() async {
    await RecentSongsController.getRecentSongs();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDB.favoriteSongs;
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: FutureBuilder(
          future: RecentSongsController.getRecentSongs(),
          builder: (context, items) {
            return ValueListenableBuilder(
              valueListenable: RecentSongsController.recentsNotifier,
              builder: (BuildContext context, List<SongModel> recentValue,
                  Widget? child) {
                if (recentValue.isEmpty) {
                  return Lottie.asset('assets/images/play.json',
                      height: 89, width: 100);
                } else {
                  final temp = recentValue.reversed.toList();
                  removedup = temp.toSet().toList();

                  return FutureBuilder<List<SongModel>>(
                      future: _audioQuery.querySongs(
                        sortType: SongSortType.TITLE,
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        ignoreCase: true,
                      ),
                      builder: (BuildContext context, item) {
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
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.025,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              removedup.length > 10 ? 10 : removedup.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.025,
                                top: MediaQuery.of(context).size.width * 0.012,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  MusicStore.player.setAudioSource(
                                      MusicStore.createSongList(removedup),
                                      initialIndex: index);
                                  // MusicStore.player.stop();
                                  MusicStore.player.play();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NowPlaying(
                                        playerSong: MusicStore.playingSong,
                                      ),
                                    ),
                                  );
                                  // MusicStore.player.stop();
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    QueryArtworkWidget(
                                      artworkQuality: FilterQuality.high,
                                      size: 2000,
                                      artworkBorder: BorderRadius.circular(15),
                                      artworkHeight:
                                          MediaQuery.of(context).size.height *
                                              0.17,
                                      artworkWidth:
                                          MediaQuery.of(context).size.width *
                                              0.34,
                                      artworkFit: BoxFit.fill,
                                      id: removedup[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image(
                                          image: const AssetImage(
                                              'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.17,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.34,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: Text(
                                                    removedup[index]
                                                        .displayNameWOExt,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                    softWrap: false,
                                                    style: const TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: Stack(children: [
                                                    Text(
                                                      removedup[index]
                                                          .album
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        foreground: Paint()
                                                          ..style =
                                                              PaintingStyle
                                                                  .stroke
                                                          ..strokeWidth = 2
                                                          ..color = Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      removedup[index]
                                                          .album
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      softWrap: false,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              Icons.play_circle,
                                              color: Colors.deepPurple,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width *
                                    //       0.15,
                                    //   child: Center(

                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                }
              },
            );
          },
        ),
      ),
    );
  }
}
