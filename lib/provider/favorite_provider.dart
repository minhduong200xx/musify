import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/models/song_model.dart';

class FavoriteSongsProvider extends ChangeNotifier {
  Set<Song> _favoriteSongs = {};
  Set<Song> _filteredSongs = {};

  Set<Song> get favoriteSongs => _favoriteSongs;

  Set<Song> get filteredSongs => _filteredSongs;

  void toggleFavorite(Song song) {
    if (_favoriteSongs.contains(song)) {
      _favoriteSongs.remove(song);
    } else {
      _favoriteSongs.add(song);
    }
    _applyFilter("");
    notifyListeners();
  }

  void removeFromFavorites(Song song) {
    _favoriteSongs.remove(song);
    _applyFilter("");
    notifyListeners();
  }

  void applyFilter(String query) {
    if (query.isEmpty) {
      _filteredSongs = _favoriteSongs;
    } else {
      _filteredSongs = _favoriteSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = song.artist.toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) || artist.contains(searchLower);
      }).toSet();
    }
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
