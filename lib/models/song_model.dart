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
    Song(
      title: 'Ae Dil Hai Mushkil',
      description: 'Ae Dil Hai Mushkil',
      url: 'assets/music/Ae_Dil_Hai_Mushkil.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'happy',
    ),
    Song(
      title: 'Baaton Ko Teri Hum Bhula Na Sake',
      description: 'Baaton Ko Teri Hum Bhula Na Sake',
      url: 'assets/music/Baaton_Ko_Teri_Hum_Bhula_Na_Sake.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'happy',
    ),
    Song(
      title: 'Dekhha Tenu',
      description: 'Dekhha Tenu',
      url: 'assets/music/Dekhha_Tenu.mp3',
      coverUrl: 'assets/images/cover.jpg',
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
    Song(
      title: 'Dil Sambhal Ja Zara',
      description: 'Dil Sambhal Ja Zara',
      url: 'assets/music/Dil_Sambhal_Ja_Zara.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'sad',
    ),
    Song(
      title: 'Gore Gore Mukhde Pe',
      description: 'Gore Gore Mukhde Pe',
      url: 'assets/music/Gore_Gore_Mukhde_Pe.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'sad',
    ),
    Song(
      title: 'Dunki O Maahi',
      description: 'Dunki O Maahi',
      url: 'assets/music/Dunki_O_Maahi.mp3',
      coverUrl: 'assets/images/cover.jpg',
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
    Song(
      title: 'Hamari Adhuri Kahani',
      description: 'Hamari Adhuri Kahani',
      url: 'assets/music/Hamari_Adhuri_Kahani.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'angry',
    ),
    Song(
      title: 'Kesariya',
      description: 'Kesariya',
      url: 'assets/music/Kesariya.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'angry',
    ),
    Song(
      title: 'KHAIRIYAT',
      description: 'KHAIRIYAT',
      url: 'assets/music/KHAIRIYAT.mp3',
      coverUrl: 'assets/images/cover.jpg',
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
    Song(
      title: 'Khudaya Sarfira',
      description: 'Khudaya Sarfira',
      url: 'assets/music/Khudaya_Sarfira.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'fear',
    ),
    Song(
      title: 'Pal',
      description: 'Pal',
      url: 'assets/music/Pal.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'fear',
    ),
    Song(
      title: 'Phir Aur Kya Chahiye',
      description: 'Phir Aur Kya Chahiye',
      url: 'assets/music/Phir_Aur_Kya_Chahiye.mp3',
      coverUrl: 'assets/images/cover.jpg',
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
    Song(
      title: 'Sajni',
      description: 'Sajni',
      url: 'assets/music/Sajni.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'disgust',
    ),
    Song(
      title: 'Tera mera pyaar he ammar.mp3',
      description: 'Tera mera pyaar he ammar',
      url: 'assets/music/Tera_mera_pyaar_he_ammar.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'disgust',
    ),
    Song(
      title: 'Tu Jo Mileya',
      description: 'Tu_Jo_Mileya',
      url: 'assets/music/Tu_Jo_Mileya.mp3',
      coverUrl: 'assets/images/cover.jpg',
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
    Song(
      title: 'Ve Kamleya',
      description: 'Ve Kamleya',
      url: 'assets/music/Ve_Kamleya.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'surprise',
    ),
    Song(
      title: 'Yimmy Yimmy',
      description: 'Yimmy Yimmy',
      url: 'assets/music/Yimmy_Yimmy.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'surprise',
    ),
    Song(
      title: 'Tera mera pyaar he ammar.mp3',
      description: 'Tera mera pyaar he ammar',
      url: 'assets/music/Tera_mera_pyaar_he_ammar.mp3',
      coverUrl: 'assets/images/cover.jpg',
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
    Song(
      title: 'Phir Aur Kya Chahiye',
      description: 'Phir Aur Kya Chahiye',
      url: 'assets/music/Phir_Aur_Kya_Chahiye.mp3',
      coverUrl: 'assets/images/cover.jpg',
      category: 'neutral',
    ),
  ];
}
