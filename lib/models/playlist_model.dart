import 'package:cloud_firestore/cloud_firestore.dart';
import 'song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String imageUrl;

  Playlist({
    required this.title,
    required this.songs,
    required this.imageUrl,
  });

  // Method to fetch songs from Firestore
  static Future<List<Song>> getAllSongsFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('songs').get();
    List<Song> songs =
        querySnapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
    return songs;
  }

  // Method to fetch playlists from Firestore
  static Future<List<Playlist>> getPlaylistsFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('playlists').get();
    List<Playlist> playlists = querySnapshot.docs
        .map(
            (doc) => Playlist.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    return playlists;
  }

  // Method to create playlists based on fetched data
  static Future<List<Playlist>> createPlaylists() async {
    List<Playlist> playlists = [];
    List<Playlist> fetchedPlaylists = await getPlaylistsFromFirestore();

    for (Playlist playlist in fetchedPlaylists) {
      List<Song> songs = await getAllSongsFromFirestore();
      List<Song> filteredSongs = songs
          .where((song) => song.playlist.contains(playlist.title))
          .toList();
      Playlist newPlaylist = Playlist(
        title: playlist.title,
        songs: filteredSongs,
        imageUrl: playlist.imageUrl,
      );
      playlists.add(newPlaylist);
    }

    return playlists;
  }

  // Factory method to create Playlist object from Firestore data
  factory Playlist.fromFirestore(Map<String, dynamic> data) {
    return Playlist(
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      songs: [], // Initially, songs are empty and will be fetched later
    );
  }
}
