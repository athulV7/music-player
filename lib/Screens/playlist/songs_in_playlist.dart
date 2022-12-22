import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:melomusic/Screens/playlist/playlist_list_allsongs.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/playlist_db.dart';
import '../../database/recent_songs_db.dart';
import '../../model/music_player.dart';
import '../now_playing/now_playing.dart';
import '../widget/music_store.dart';

class PlaylistData extends StatefulWidget {
  const PlaylistData(
      {super.key, required this.playlist, required this.folderIndex});

  final MusicPlayer playlist;
  final int folderIndex;

  @override
  State<PlaylistData> createState() => _PlaylistDataState();
}

class _PlaylistDataState extends State<PlaylistData> {
  late List<SongModel> playlistsong;

  @override
  Widget build(BuildContext context) {
    PlaylistDB.getAllPlaylist();
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
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.playlist.name,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<MusicPlayer>('playlistDB').listenable(),
          builder:
              (BuildContext context, Box<MusicPlayer> value, Widget? child) {
            playlistsong =
                listPlaylist(value.values.toList()[widget.folderIndex].songIds);

            return playlistsong.isEmpty
                ? const Center(
                    child: Text(
                      'No songs in this playlist',
                      style: TextStyle(
                          color: Colors.white, letterSpacing: 1, fontSize: 15),
                    ),
                  )
                : ListView.separated(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        onTap: () {
                          List<SongModel> newList = [...playlistsong];

                          MusicStore.player.stop();
                          MusicStore.player.setAudioSource(
                            MusicStore.createSongList(newList),
                            initialIndex: index,
                          );
                          MusicStore.player.play();
                          RecentSongsController.addRecentlyPlayed(
                              newList[index].id);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => NowPlaying(
                                playerSong: MusicStore.playingSong,
                                //playlistsong,
                              ),
                            ),
                          );
                        },
                        leading: QueryArtworkWidget(
                          id: playlistsong[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                                'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                          ),
                          // errorBuilder: (context, excepion, gdb) {
                          //   setState(() {});
                          //   return Image.asset('');
                          // },
                        ),
                        title: Text(
                          playlistsong[index].displayNameWOExt,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Text(
                            playlistsong[index].artist!,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 230, 225, 225),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        trailing: Container(
                          width: MediaQuery.of(context).size.width * 0.09,
                          height: MediaQuery.of(context).size.width * 0.09,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: IconButton(
                            onPressed: () {
                              widget.playlist
                                  .deleteData(playlistsong[index].id);
                            },
                            icon: const Icon(
                              Icons.playlist_remove_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider();
                    },
                    itemCount: playlistsong.length,
                  );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => SongsList(
                  playList: widget.playlist,
                ),
              ),
            );
          },
          label: const Text(
            'Add song',
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.deepPurple.shade800,
        ),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> pListSongs = [];
    for (int i = 0; i < MusicStore.songCopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (MusicStore.songCopy[i].id == data[j]) {
          pListSongs.add(MusicStore.songCopy[i]);
        }
      }
    }
    return pListSongs;
  }
}
