class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;
  final String artist;
  bool isFavorite;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
    required this.artist,
    this.isFavorite = false,
  });

  static List<Song> songs = [
    Song(
      title: 'Glass',
      description: 'Glass',
      url: 'assets/music/glass.mp3',
      coverUrl: 'assets/images/glass.jpg',
      artist: 'Artist Name 1',
    ),
    Song(
      title: 'Illusions',
      description: 'Illusions',
      url: 'assets/music/illusions.mp3',
      coverUrl: 'assets/images/illusions.jpg',
      artist: 'Artist Name 2',
    ),
    Song(
      title: 'Pray',
      description: 'Pray',
      url: 'assets/music/pray.mp3',
      coverUrl: 'assets/images/pray.jpg',
      artist: 'Artist Name 3',
    ),
    Song(
      title: 'Mặt trời ',
      description: 'Mặt trời của em',
      url: 'assets/music/mattroi.mp3',
      coverUrl: 'assets/images/pray.jpg',
      artist: 'Artist Name 3',
    ),
  ];
}
