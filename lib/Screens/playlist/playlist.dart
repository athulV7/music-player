import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:melomusic/Screens/playlist/songs_in_playlist.dart';

import '../../database/playlist_db.dart';
import '../../model/music_player.dart';
import '../favorites/favorites.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

final nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
const subimg = "assets/images/favorite-folder-3023940.png";

class _PlaylistState extends State<Playlist> {
  bool? an;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicPlayer>('playlistDB').listenable(),
      builder:
          (BuildContext context, Box<MusicPlayer> musicList, Widget? child) {
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
                'Playlists',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        right: MediaQuery.of(context).size.width * 0.03,
                      ),
                      child: ListTile(
                        horizontalTitleGap: 11,
                        contentPadding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.03,
                        ),
                        tileColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: Lottie.asset('assets/images/8579-like.json',
                            height: 89, width: 80),
                        title: const Text(
                          'Favorites',
                          style: TextStyle(
                            fontSize: 17,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white38,
                          size: 20,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Favorites();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .018,
                    ),
                    Hive.box<MusicPlayer>('playlistDB').isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.5,
                              ),
                              child: const Text(
                                'No Playlists',
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: musicList.length,
                            itemBuilder: (
                              BuildContext context,
                              index,
                            ) {
                              final data = musicList.values.toList()[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: ListTile(
                                  tileColor: Colors.white.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.050,
                                    ),
                                    child: Text(
                                      data.name,
                                      style: const TextStyle(
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  leading: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    height: MediaQuery.of(context).size.width *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.playlist_play,
                                        color: Colors.white,
                                        size: 27,
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      const Duration(seconds: 3);

                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: const Text(
                                            'Are you sure you want to delete this playlist?',
                                            style: TextStyle(
                                              color: Colors.black,
                                              height: 2,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  musicList.deleteAt(index);
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.playlist_remove,
                                      color: Colors.red,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PlaylistData(
                                            playlist: data,
                                            folderIndex: index,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.deepPurple.shade500,
              label: const Text('Add'),
              icon: const Icon(Icons.playlist_add),
              onPressed: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        height: 250,
                        color: Colors.transparent,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.12,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      cursorColor: Colors.deepPurple,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.playlist_play_outlined,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.deepPurple),
                                          borderRadius:
                                              BorderRadius.circular(35),
                                        ),
                                        filled: true,
                                        hintText: 'Playlist Name',
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                        ),
                                      ),
                                      validator: ((value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter playlist name";
                                        } else {
                                          return null;
                                        }
                                      }),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: ElevatedButton(
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.deepPurple),
                                        ),
                                        onPressed: () => Navigator.pop(
                                          context,
                                        ),
                                        child: const Text(
                                          'Cancel',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.deepPurple),
                                          ),
                                          child: const Text(
                                            'Save',
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              buttonClicked();
                                              Navigator.pop(context);
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> buttonClicked() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayer(
        name: name,
        songIds: [],
      );
      PlaylistDB.addPlaylist(music);
      nameController.clear();
    }
  }
}
