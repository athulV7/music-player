import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/recent_songs_db.dart';
import '../now_playing/now_playing.dart';
import '../widget/music_store.dart';

ValueNotifier<List<SongModel>> temp = ValueNotifier([]);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  late List<SongModel> _allSongs;
  List<SongModel> getedSongs = [];

  void loadAllSongList() async {
    _allSongs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    getedSongs = _allSongs;
  }

  void search(String typedKeyword) {
    List<SongModel> results = [];
    if (typedKeyword.isEmpty) {
      results = _allSongs;
    } else {
      results = _allSongs
          .where(
            (element) => element.title.toLowerCase().contains(
                  typedKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      getedSongs = results;
    });
  }

  @override
  void initState() {
    loadAllSongList();
    super.initState();
  }

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
            'Search',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                child: TextField(
                  cursorColor: Colors.deepPurple,
                  autofocus: true,
                  onChanged: (String value) => search(value),
                  style: const TextStyle(color: Color.fromARGB(255, 5, 31, 53)),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search',
                    fillColor: const Color.fromARGB(255, 215, 214, 215),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 5, 31, 53),
                    ),
                  ),
                ),
              ),
              (getedSongs.isEmpty)
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: getedSongs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: QueryArtworkWidget(
                              id: getedSongs[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                    'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                              ),
                            ),
                            title: Text(
                              getedSongs[index].displayNameWOExt,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              "${getedSongs[index].artist}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 223, 219, 219),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                            ),
                            onTap: () {
                              getedSongs;
                              FocusScope.of(context).unfocus();
                              MusicStore.player.setAudioSource(
                                MusicStore.createSongList(getedSongs),
                                initialIndex: index,
                              );
                              MusicStore.player.play();
                              RecentSongsController.addRecentlyPlayed(
                                  getedSongs[index].id);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      NowPlaying(playerSong: getedSongs)));
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
