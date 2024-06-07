import 'package:emosift/models/playlist_model.dart';
import 'package:emosift/widgets/playlist_card.dart';
import 'package:emosift/widgets/section_header.dart';
import 'package:flutter/material.dart';

class PlaylistMusicsScreen extends StatelessWidget {
  const PlaylistMusicsScreen({
    Key? key,
    required this.playlists,
  }) : super(key: key);

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900.withOpacity(0.3),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SectionHeader(title: 'Playlists'),
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 20),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlists.length,
              itemBuilder: ((context, index) {
                return PlaylistCard(playlist: playlists[index]);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
