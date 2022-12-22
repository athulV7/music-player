import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/favorite_db.dart';
import '../all_music/all_music.dart';
import '../home/home_screen.dart';
import '../home/mini_player.dart';
import '../playlist/playlist.dart';
import '../setting/settings.dart';
import 'music_store.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int index = 0;
  final screens = const [
    HomeScreen(),
    AllMusic(),
    Playlist(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: FavoriteDB.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> favordata, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (MusicStore.player.currentIndex != null)
                    Column(
                      children: const [
                        MiniPlayer(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  Column(
                    children: [
                      NavigationBarTheme(
                        data: NavigationBarThemeData(
                          indicatorColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          labelTextStyle: MaterialStateProperty.all(
                            const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        child: NavigationBar(
                          elevation: 0,
                          height: 75,
                          labelBehavior: NavigationDestinationLabelBehavior
                              .onlyShowSelected,
                          selectedIndex: index,
                          backgroundColor: Colors.deepPurple.shade800,
                          animationDuration: const Duration(seconds: 3),
                          onDestinationSelected: (index) =>
                              // setState(
                              //   () => this.index = index,
                              // ),
                              setState(() {
                            this.index = index;
                            FavoriteDB.favoriteSongs.notifyListeners();
                          }),
                          destinations: const [
                            NavigationDestination(
                              icon: Icon(
                                Icons.home_outlined,
                                color: Colors.white,
                              ),
                              selectedIcon: Icon(
                                Icons.home,
                                color: Colors.deepPurple,
                              ),
                              label: 'Home',
                            ),
                            NavigationDestination(
                              icon: Icon(
                                Icons.album_outlined,
                                color: Colors.white,
                              ),
                              selectedIcon: Icon(
                                Icons.album,
                                color: Colors.deepPurple,
                              ),
                              label: 'Musics',
                            ),
                            NavigationDestination(
                              icon: Icon(
                                Icons.playlist_play,
                                color: Colors.white,
                              ),
                              selectedIcon: Icon(
                                Icons.playlist_play_outlined,
                                color: Colors.deepPurple,
                              ),
                              label: 'Playlist',
                            ),
                            NavigationDestination(
                              icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              selectedIcon: Icon(
                                Icons.settings,
                                color: Colors.deepPurple,
                              ),
                              label: 'Settings ',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
