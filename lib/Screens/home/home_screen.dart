import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../database/favorite_db.dart';
import '../../database/recent_songs_db.dart';
import '../all_music/all_music.dart';
import '../favorites/favorites.dart';
import '../favorites/home_liked.dart';
import '../now_playing/now_playing.dart';
import '../search/search.dart';
import '../widget/music_store.dart';
import 'home_recents.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static List<SongModel> song = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }

    Permission.storage.request();
  }

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
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.025,
                  ),
                  const Text(
                    'Enjoy Your Favourite Music',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true),
                builder: (BuildContext context, item) {
                  if (item.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (item.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Songs Found',
                      ),
                    );
                  }
                  AllMusic.song = item.data!;
                  // HomeScreen.album = item.data!;

                  if (!FavoriteDB.isInitialized) {
                    FavoriteDB.initialize(item.data!);
                  }
                  MusicStore.songCopy = item.data!;

                  return CarouselSlider.builder(
                    itemBuilder:
                        (BuildContext context, int index, int pageViewIndex) {
                      return ValueListenableBuilder(
                        valueListenable: RecentSongsController.recentsNotifier,
                        builder: (BuildContext context,
                            List<SongModel> recentValue, Widget? child) {
                          return GestureDetector(
                            onTap: () {
                              MusicStore.player.stop();

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
                                          //item.data!
                                        )),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: MediaQuery.of(context).size.height * 0.16,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.023,
                                ),
                                child: ListView(
                                  children: [
                                    QueryArtworkWidget(
                                      keepOldArtwork: true,
                                      quality: 100,
                                      artworkQuality: FilterQuality.high,
                                      size: 2000,
                                      id: item.data![index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkFit: BoxFit.fill,
                                      nullArtworkWidget: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          image: const AssetImage(
                                              'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.16,
                                        ),
                                      ),
                                      artworkBorder: const BorderRadius.all(
                                        Radius.circular(
                                          10,
                                        ),
                                      ),
                                      artworkWidth:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      artworkHeight:
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                      item.data![index].title,
                                      style: const TextStyle(letterSpacing: 1),
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    options: CarouselOptions(
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      aspectRatio: 16 / 90,
                      height: MediaQuery.of(context).size.width * 0.48,
                      viewportFraction: 0.4,
                      autoPlay: true,
                      autoPlayCurve: Curves.easeInQuint,
                      enlargeCenterPage: true,
                    ),
                    itemCount: item.data!.length,
                  );
                  // });
                  // SizedBox(
                  //   height: 10,
                  // );
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 24),
              child: const Text(
                'Recently Played',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            const HomeRecentsSongs(),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 24,
                right: MediaQuery.of(context).size.width / 50,
                top: MediaQuery.of(context).size.width / 17,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Liked Songs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Favorites(),
                        ),
                      );
                    },
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const HomeLiked(),
          ],
        ),
      ),
    );
  }
}
