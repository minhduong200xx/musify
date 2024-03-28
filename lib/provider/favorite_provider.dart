import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/models/song_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteSongsProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Set<Song> _favoriteSongs = {};
  Set<Song> _filteredSongs = {};

  Set<Song> get favoriteSongs => _favoriteSongs;

  Set<Song> get filteredSongs => _filteredSongs;

  Future<void> fetchFavoriteSongs(String userId) async {
    try {
      final favoritesSnapshot = await firestore
          .collection('favorites')
          .doc(userId)
          .collection('songs')
          .get();
      _favoriteSongs =
          favoritesSnapshot.docs.map((doc) => Song.fromFirestore(doc)).toSet();
      _applyFilter("");
      notifyListeners();
    } catch (e) {
      print('Error fetching favorite songs: $e');
    }
  }

  void toggleFavorite(Song song, String userId) async {
    try {
      if (userId.isEmpty) {
        print('Error toggling favorite song: userId is empty');
        return;
      }

      final songRef = firestore
          .collection('favorites')
          .doc(userId)
          .collection('songs')
          .doc(song.id);

      if (_favoriteSongs.contains(song)) {
        _favoriteSongs.remove(song);
        await songRef.delete();
      } else {
        _favoriteSongs.add(song);
        await songRef.set({
          'title': song.title,
          'artist': song.artist,
          'coverUrl': song.coverImageUrl,
          'url': song.audioUrl,
          'singer': song.singer,
          'playlist': song.playlist,
          'isFavorite': true,
        });
      }
      _applyFilter("");
      notifyListeners();
    } catch (e) {
      print('Error toggling favorite song: $e');
    }
  }

  void removeFromFavorites(Song song, String userId) async {
    try {
      _favoriteSongs.remove(song);
      await firestore
          .collection('favorites')
          .doc(userId)
          .collection('songs')
          .doc(song.id)
          .delete();
      _applyFilter("");
      notifyListeners();
    } catch (e) {
      print('Error removing favorite song: $e');
    }
  }

  void applyFilter(String query) {
    _applyFilter(query);
    notifyListeners();
  }

  void _applyFilter(String query) {
    _filteredSongs = query.isEmpty
        ? _favoriteSongs
        : _favoriteSongs.where((song) {
            final title = song.title.toLowerCase();
            final artist = song.artist.toLowerCase();
            final searchLower = query.toLowerCase();
            return title.contains(searchLower) || artist.contains(searchLower);
          }).toSet();
  }
}
