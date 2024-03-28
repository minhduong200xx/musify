import 'package:cloud_firestore/cloud_firestore.dart';
import 'song_model.dart';

class Playlist {
  final String id;
  final String title;
  final List<Song> songs;
  final String imageUrl;

  Playlist({
    required this.id,
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
        id: playlist.id, // Include playlist ID
        title: playlist.title,
        songs: filteredSongs,
        imageUrl: playlist.imageUrl,
      );
      playlists.add(newPlaylist);
    }

    return playlists;
  }

  // Method to add a song to the playlist and update Firestore
  Future<void> addSong(Song song) async {
    // Add the song to the local songs list
    songs.add(song);

    // Update the Firestore document to reflect the change
    try {
      await FirebaseFirestore.instance.collection('playlists').doc(id).update({
        'songs': FieldValue.arrayUnion(
            [song.id]), // Assuming song.id is the ID of the song
      });
      // If successful, you might want to show a message or perform other actions
      print('Song added to the playlist successfully.');
    } catch (error) {
      // Handle any errors that might occur during the update process
      print('Error adding song to the playlist: $error');
    }
  }

  // Factory method to create Playlist object from Firestore data
  factory Playlist.fromFirestore(Map<String, dynamic> data) {
    return Playlist(
      id: data['id'] ?? '', // Include id field
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      songs: [], // Initially, songs are empty and will be fetched later
    );
  }
}
