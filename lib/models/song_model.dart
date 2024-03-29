import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String coverImageUrl;
  final String audioUrl;
  final String singer;
  final String playlist;
  bool isFavorite;

  Song({
    required this.id,
    required this.playlist,
    required this.singer,
    required this.title,
    required this.artist,
    required this.coverImageUrl,
    required this.audioUrl,
    this.isFavorite = false,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Song(
      // Assigning id from document snapshot
      id: data['id'].toString(),
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      coverImageUrl: data['coverUrl'] ?? '',
      audioUrl: data['url'] ?? '',
      singer: data['singer'] ?? '',
      playlist: data['playlist'] ?? '',
    );
  }
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<List<Song>> fetchSongs() async {
  final songsSnapshot = await firestore.collection('songs').get();
  return Future.wait(songsSnapshot.docs.map((doc) async {
    Song song = Song.fromFirestore(doc);
    await firestore
        .collection('favorites')
        .doc(song.id)
        .get()
        .then((snapshot) => song.isFavorite = snapshot.exists);
    return song;
  }).toList());
}

Future<Song?> getNextSong(String currentSongId) async {
  try {
    final songsSnapshot = await FirebaseFirestore.instance
        .collection('songs')
        .orderBy('id')
        .startAfter([int.parse(currentSongId)])
        .limit(1)
        .get();

    final List<QueryDocumentSnapshot> docs = songsSnapshot.docs;
    if (docs.isNotEmpty) {
      final doc = docs.first;
      final song = Song.fromFirestore(doc);
      print(currentSongId);
      print(song.title);
      return song;
    } else {
      return null;
    }
  } catch (e) {
    print('Error getting next song: $e');
    return null;
  }
}

Future<Song?> getPreviousSong(String currentSongId) async {
  try {
    final currentSongIdInt = int.parse(currentSongId);
    final songsSnapshot = await FirebaseFirestore.instance
        .collection('songs')
        .where('id', isLessThan: currentSongIdInt)
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    final List<QueryDocumentSnapshot> docs = songsSnapshot.docs;
    if (docs.isNotEmpty) {
      final doc = docs.first;
      final song = Song.fromFirestore(doc);
      print(currentSongId);
      print(song.title);
      return song;
    } else {
      print("No previous song found.");
      return null;
    }
  } catch (e) {
    print('Error getting previous song: $e');
    return null;
  }
}

Future<Song?> getRandomSong() async {
  try {
    final int songCount = await FirebaseFirestore.instance
        .collection('songs')
        .get()
        .then((querySnapshot) => querySnapshot.size);

    int randomIndex = Random().nextInt(songCount);
    final songsSnapshot = await FirebaseFirestore.instance
        .collection('songs')
        .where('id', isEqualTo: randomIndex)
        .limit(1)
        .get();

    final List<QueryDocumentSnapshot> docs = songsSnapshot.docs;
    if (docs.isNotEmpty) {
      final doc = docs.first;
      final song = Song.fromFirestore(doc);
      print(song.title);
      return song;
    } else {
      return null;
    }
  } catch (e) {
    print('Error getting random song: $e');
    return null;
  }
}
