import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  // Added id field
  final String title;
  final String artist;
  final String coverImageUrl;
  final String audioUrl;
  final String singer;
  final String playlist;
  final String fileName;
  Song({
    required this.playlist,
    required this.singer,
    // Updated constructor to accept id
    required this.title,
    required this.fileName,
    required this.artist,
    required this.coverImageUrl,
    required this.audioUrl,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Song(
        // Assigning id from document snapshot
        title: data['title'] ?? '',
        artist: data['artist'] ?? '',
        coverImageUrl: data['coverUrl'] ?? '',
        audioUrl: data['url'] ?? '',
        singer: data['singer'] ?? '',
        playlist: data['playlist'] ?? '',
        fileName: data['fileName'] ?? '');
  }
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<List<Song>> fetchSongs() async {
  final songsSnapshot = await firestore.collection('songs').get();
  return songsSnapshot.docs
      .map((doc) =>
          Song.fromFirestore(doc)) // Passing document snapshot directly
      .toList();
}
