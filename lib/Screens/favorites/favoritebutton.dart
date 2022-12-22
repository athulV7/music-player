import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../database/favorite_db.dart';

class FavoriteBut extends StatefulWidget {
  const FavoriteBut({Key? key, required this.song}) : super(key: key);
  final SongModel song;

  @override
  State<FavoriteBut> createState() => _FavoriteButState();
}

class _FavoriteButState extends State<FavoriteBut> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDB.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favorData, Widget? child) {
        return IconButton(
          onPressed: () {
            if (FavoriteDB.isfavor(widget.song)) {
              FavoriteDB.delete(widget.song.id);
              const snackBar = SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'Removed From Favorites',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              FavoriteDB.add(widget.song);

              const snackbar = SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'Song Added to Favorite',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }

            FavoriteDB.favoriteSongs.notifyListeners();
          },
          icon: FavoriteDB.isfavor(widget.song)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
        );
      },
    );
  }
}
