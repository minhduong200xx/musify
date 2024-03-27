import 'auth_model.dart';

class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;
  final String artist;
  final String listens;
  bool isFavorite;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
    required this.artist,
    required this.listens,
    this.isFavorite = false,
  });

  Auth? get artistInfo => Auth.findArtistByName(artist);

  static List<Song> songs = [
    Song(
        title: 'Glass',
        description: 'Glass',
        url: 'assets/music/glass.mp3',
        coverUrl: 'assets/images/glass.jpg',
        artist: 'Artist Name 1',
        listens: '123423'),
    Song(
        title: 'Illusions',
        description: 'Illusions',
        url: 'assets/music/illusions.mp3',
        coverUrl: 'assets/images/illusions.jpg',
        artist: 'Artist Name 2',
        listens: '123423'),
    Song(
        title: 'Pray',
        description: 'Pray',
        url: 'assets/music/pray.mp3',
        coverUrl: 'assets/images/pray.jpg',
        artist: 'Artist Name 3',
        listens: '123423'),
    Song(
        title: 'Mặt trời của em ',
        description: 'Mặt trời của em',
        url: 'assets/music/mattroi.mp3',
        coverUrl: 'assets/images/pray.jpg',
        artist: 'Phương Ly',
        listens: '3.628.391'),
  ];
}
