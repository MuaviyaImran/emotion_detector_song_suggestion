class Song {
  final String title;
  final String description;
  final String url;
  bool isFavorite;

  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
    this.isFavorite = false,
  });

  static List<Song> songs = [
    Song(
      title: 'Kun Anta',
      description: 'Kun Anta',
      url: 'assets/music/Kun_anta.mp3',
      coverUrl: 'assets/images/Allah.jpg',
    ),
    Song(
      title: 'Ya Ahdeem',
      description: 'Ya Adheem',
      url: 'assets/music/Ya_adheeman.mp3',
      coverUrl: 'assets/images/ya_adheem.jpg',
    ),
    Song(
      title: 'Muhammad Nabina',
      description: 'Muhammad Nabina',
      url: 'assets/music/nabina.mp3',
      coverUrl: 'assets/images/nabina.jpg',
    ),
    Song(
      title: 'Subhan Allah',
      description: 'Subhan Allah',
      url: 'assets/music/tasbih.mp3',
      coverUrl: 'assets/images/tasbih.jpg',
    ),
    Song(
      title: 'Jamal ul Wajood',
      description: 'Jamal ul Wajood',
      url: 'assets/music/jamal_ul.mp3',
      coverUrl: 'assets/images/jamal_ul.jpg',
    )
  ];
}
