import 'package:flutter/material.dart';

class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;
  final String category; // New field
  bool isFavorite;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
    required this.category, // Updated constructor
    this.isFavorite = false,
  });
// CATEGORIES
//  *happy
//  *sad
//  *angry
//  *fear
//  *disgust
//  *surprise
//  *neutral

  static List<Song> songs = [
    // HAPPY SONGS HERE
    Song(
      title: 'Kun Anta',
      description: 'Kun Anta',
      url: 'assets/music/Kun_anta.mp3',
      coverUrl: 'assets/images/Allah.jpg',
      category: 'happy',
    ),
    // SAD SONGS HERE
    Song(
      title: 'Ya Ahdeem',
      description: 'Ya Adheem',
      url: 'assets/music/Ya_adheeman.mp3',
      coverUrl: 'assets/images/ya_adheem.jpg',
      category: 'sad',
    ),
    // ANGRY SONGS HERE
    Song(
      title: 'Muhammad Nabina',
      description: 'Muhammad Nabina',
      url: 'assets/music/nabina.mp3',
      coverUrl: 'assets/images/nabina.jpg',
      category: 'angry',
    ),
    // FEAR SONGS HERE
    Song(
      title: 'Subhan Allah',
      description: 'Subhan Allah',
      url: 'assets/music/tasbih.mp3',
      coverUrl: 'assets/images/tasbih.jpg',
      category: 'fear',
    ),
    // DISGUST SONGS HERE
    Song(
      title: 'Jamal ul Wajood',
      description: 'Jamal ul Wajood',
      url: 'assets/music/jamal_ul.mp3',
      coverUrl: 'assets/images/jamal_ul.jpg',
      category: 'disgust',
    ),
    // SURPRISE SONGS HERE
    Song(
      title: 'Ya Ahdeem',
      description: 'Ya Adheem',
      url: 'assets/music/Ya_adheeman.mp3',
      coverUrl: 'assets/images/ya_adheem.jpg',
      category: 'surprise',
    ),
    // NEUTRAL SONGS HERE
    Song(
      title: 'Muhammad Nabina',
      description: 'Muhammad Nabina',
      url: 'assets/music/nabina.mp3',
      coverUrl: 'assets/images/nabina.jpg',
      category: 'neutral',
    ),
  ];
}
