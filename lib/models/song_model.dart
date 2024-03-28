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
      id: doc.id,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      coverImageUrl: data['coverUrl'] ?? '',
      audioUrl: data['url'] ?? '',
      singer: data['singer'] ?? '',
      playlist: data['playlist'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Future<void> addToPlaylist(String playlistId) async {
    try {
      await firestore.collection('playlists').doc(playlistId).update({
        'songs': FieldValue.arrayUnion([this.id])
      });
      this.isFavorite = true;
    } catch (e) {
      print('Error adding song to playlist: $e');
    }
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
