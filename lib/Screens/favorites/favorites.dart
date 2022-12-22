import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../database/favorite_db.dart';
import '../../database/recent_songs_db.dart';
import '../now_playing/now_playing.dart';
import '../widget/music_store.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDB.favoriteSongs,
        builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
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
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.05,
                ),
                child:
                    // FavoriteDB.favoriteSongs.value.isEmpty
                    //     ? const Center(
                    //         child: Text(
                    //         'No Favorites songs',
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ))
                    //     :
                    ListView(
                  children: [
                    FutureBuilder(builder: (context, item) {
                      return ValueListenableBuilder(
                        valueListenable: FavoriteDB.favoriteSongs,
                        builder: (BuildContext ctx, List<SongModel> favorData,
                            Widget? child) {
                          return favorData.isEmpty
                              ? const Center(
                                  child: Text(
                                  'No Favorites songs',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (ctx, index) {
                                    return ListTile(
                                      onTap: () {
                                        List<SongModel> newlist = [
                                          ...favorData
                                        ];
                                        // MusicStore.player.stop();
                                        MusicStore.player.setAudioSource(
                                            MusicStore.createSongList(newlist),
                                            initialIndex: index);
                                        MusicStore.player.play();
                                        RecentSongsController.addRecentlyPlayed(
                                            newlist[index].id);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (ctx) {
                                            return NowPlaying(
                                              playerSong:
                                                  MusicStore.playingSong,
                                            );
                                          }),
                                        );
                                      },
                                      leading: QueryArtworkWidget(
                                        id: favorData[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                              'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                                        ),
                                      ),
                                      title: Text(
                                        favorData[index].displayNameWOExt,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        favorData[index].artist.toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            FavoriteDB.favoriteSongs
                                                .notifyListeners();
                                            FavoriteDB.delete(
                                                favorData[index].id);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 23,
                                          )),
                                    );
                                  },
                                  separatorBuilder: (ctx, index) {
                                    return const Divider();
                                  },
                                  itemCount: favorData.length);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
