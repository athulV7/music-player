import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:restart_app/restart_app.dart';

import '../model/music_player.dart';
import 'favorite_db.dart';
import 'recent_songs_db.dart';

class PlaylistDB {
  static ValueNotifier<List<MusicPlayer>> playlistNotifier = ValueNotifier([]);
  static Future<void> addPlaylist(MusicPlayer value) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    playlistNotifier.value.add(value);
    await playlistDb.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  static Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    await playlistDb.deleteAt(index);
    getAllPlaylist();
  }

  static Future<void> appReset(context) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    final musicDb = Hive.box<int>('favoriteDB');
    final dbBox = await Hive.openBox('recentsNotifier');

    await playlistDb.clear();
    await musicDb.clear();
    await dbBox.clear();
    RecentSongsController.recentPlayed.clear();
    FavoriteDB.favoriteSongs.value.clear();

    Restart.restartApp(webOrigin: 'SplashScreen');
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => const ScreenHome()),
    //   (route) => false,
    // );
  }
}
