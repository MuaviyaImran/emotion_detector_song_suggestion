import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song_model.dart';

class SongCard extends StatefulWidget {
  const SongCard({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  _SongCardState createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  final FavoritesController favoritesController = Get.find();

  late AudioPlayer _audioPlayer;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _isPlaying = false;

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _playPauseSong(widget.song);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            InkWell(
              onTap: () {
                Get.toNamed('/song', arguments: widget.song);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width * 0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: AssetImage(
                      widget.song.coverUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.song.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        widget.song.isFavorite = !widget.song.isFavorite;

                        if (widget.song.isFavorite) {
                          favoritesController.addToFavorites(widget.song);
                        } else {
                          favoritesController.removeFromFavorites(widget.song);
                        }

                        // Notify the UI that the state has changed
                        Get.forceAppUpdate();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.47,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white.withOpacity(0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.song.title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        widget.song.description,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  PlayButton(
                    isPlaying: _isPlaying,
                    onPlay: () {
                      _playPauseSong(widget.song);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playPauseSong(Song song) {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.stop();
      _audioPlayer.setUrl('asset:///${song.url}');
      _audioPlayer.play();
    }
  }
}

class PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlay;

  const PlayButton({
    Key? key,
    required this.isPlaying,
    required this.onPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
      ),
      onPressed: onPlay,
    );
  }
}

class FavoritesController extends GetxController {
  final RxList<Song> favoriteSongs = <Song>[].obs;

  void addToFavorites(Song song) {
    if (!favoriteSongs.contains(song)) {
      favoriteSongs.add(song);
    }
  }

  void removeFromFavorites(Song song) {
    favoriteSongs.remove(song);
  }

  void dislike(Song song) {
    removeFromFavorites(song);
  }
}
