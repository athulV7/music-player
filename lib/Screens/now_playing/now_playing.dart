import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../favorites/favoritebutton.dart';
import '../widget/music_store.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key, required this.playerSong});
  final List<SongModel> playerSong;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isShuffle = false;
  int currentIndex = 0;

  @override
  void initState() {
    MusicStore.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
        MusicStore.currentIndes = index;
      }
    });
    super.initState();
    playSong();
    setState(() {});
  }

  void playSong() {
    MusicStore.player.durationStream.listen((d) {
      try {
        if (mounted) {
          if (d == null) {
            return;
          }
          setState(() {
            _duration = d;
          });
        }
      } catch (e) {
        log(e.toString());
      }
    });

    MusicStore.player.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              QueryArtworkWidget(
                  artworkQuality: FilterQuality.high,
                  size: 2000,
                  keepOldArtwork: true,
                  id: widget.playerSong[currentIndex].id,
                  type: ArtworkType.AUDIO),
              ClipRRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 45.0, sigmaY: 45.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                    )),
              ),
            ],
          ),
          const _BackgroundFilter(),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.6),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.27,
                  width: MediaQuery.of(context).size.width * 0.59,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(6, 7),
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QueryArtworkWidget(
                    id: widget.playerSong[currentIndex].id,
                    type: ArtworkType.AUDIO,
                    artworkQuality: FilterQuality.high,
                    size: 2000,
                    artworkFit: BoxFit.fill,
                    artworkBorder: BorderRadius.circular(16),
                    keepOldArtwork: true,
                    nullArtworkWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: const Image(
                        image: AssetImage(
                            'assets/images/3207a9c3faa9e34737220005637d0bd0.jpg'),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 16,
                    right: MediaQuery.of(context).size.width / 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: MarqueeText(
                              text: TextSpan(
                                text: widget
                                    .playerSong[currentIndex].displayNameWOExt,
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              speed: 8,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            widget.playerSong[currentIndex].artist.toString() ==
                                    "<unknown>"
                                ? "Unknown Artist"
                                : widget.playerSong[currentIndex].artist
                                    .toString(),
                            style: const TextStyle(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                      FavoriteBut(song: widget.playerSong[currentIndex])
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 16,
                    right: MediaQuery.of(context).size.width / 18,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _position.toString().split(".")[0],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2.0,
                          trackShape: const RectangularSliderTrackShape(),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 5.0,
                          ),
                        ),
                        child: Expanded(
                          child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                            thumbColor: Colors.white,
                            min: const Duration(microseconds: 0)
                                .inSeconds
                                .toDouble(),
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                changeToSeconds(value.toInt());
                                value = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Text(
                        _duration.toString().split(".")[0],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent),
                            onPressed: () {
                              MusicStore.player.loopMode == LoopMode.one
                                  ? MusicStore.player.setLoopMode(LoopMode.off)
                                  : MusicStore.player.setLoopMode(LoopMode.one);
                            },
                            child: StreamBuilder<LoopMode>(
                              stream: MusicStore.player.loopModeStream,
                              builder: (context, snapshot) {
                                final loopMode = snapshot.data;
                                if (LoopMode.one == loopMode) {
                                  return const Icon(
                                    Icons.repeat_one,
                                    color: Colors.white,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.repeat,
                                    color: Colors.white,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              if (MusicStore.player.hasPrevious) {
                                await MusicStore.player.seekToPrevious();
                                await MusicStore.player.play();
                              } else {
                                await MusicStore.player.play();
                              }
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (MusicStore.player.playing) {
                                  MusicStore.player.pause();
                                } else {
                                  MusicStore.player.play();
                                }
                              });
                            },
                            icon: Icon(
                              MusicStore.player.playing
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 65,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              if (MusicStore.player.hasNext) {
                                await MusicStore.player.seekToNext();
                                await MusicStore.player.play();
                              } else {
                                await MusicStore.player.play();
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              _isShuffle == false
                                  ? MusicStore.player
                                      .setShuffleModeEnabled(true)
                                  : MusicStore.player
                                      .setShuffleModeEnabled(false);
                            },
                            icon: StreamBuilder<bool>(
                              stream:
                                  MusicStore.player.shuffleModeEnabledStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                _isShuffle = snapshot.data;
                                if (_isShuffle == false) {
                                  return const Icon(
                                    Icons.shuffle,
                                    size: 22,
                                    color: Colors.white,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.shuffle,
                                    color: Colors.green,
                                    size: 22,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    MusicStore.player.seek(duration);
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800,
            ],
          ),
        ),
      ),
    );
  }
}
