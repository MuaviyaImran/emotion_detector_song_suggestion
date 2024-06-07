import 'package:emosift/widgets/song_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesPage extends StatelessWidget {
  final FavoritesController favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Favorites',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: favoritesController.favoriteSongs.length,
          itemBuilder: (context, index) {
            final song = favoritesController.favoriteSongs[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text(song.title),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      favoritesController.dislike(song);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
