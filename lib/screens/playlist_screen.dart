import 'package:emosift/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/playlist_model.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Playlist playlist = Playlist.playlists[0];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade800.withOpacity(0.8),
            Colors.blue.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Playlist',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _PlaylistInformation(playlist: playlist),
                const SizedBox(height: 30),
                _PlaylistSongs(playlist: playlist),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistSongs extends StatelessWidget {
  const _PlaylistSongs({
    Key? key,
    required this.playlist,
    this.song,
  }) : super(key: key);

  final Playlist playlist;
  final Song? song;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlist.songs.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              onTap: () {
                Get.toNamed('/song', arguments: song);
              },
              leading: Text(
                '${index + 1}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              title: Text(
                playlist.songs[index].title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                '${playlist.songs[index].description} ⚬ 02:45',
                style: TextStyle(color: Colors.grey.shade300),
              ),
              trailing: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            Divider(
              thickness: 0.2,
            )
          ],
        );
      },
    );
  }
}

class _PlaylistInformation extends StatelessWidget {
  const _PlaylistInformation({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            playlist.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          playlist.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
