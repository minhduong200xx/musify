import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/screens/playlist_screen.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

class AddToPlaylistScreen extends StatelessWidget {
  final Song song;

  const AddToPlaylistScreen({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Playlist'),
      ),
      body: FutureBuilder<List<Playlist>>(
        future: Playlist.getPlaylistsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No playlists available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final playlist = snapshot.data![index];
                return ListTile(
                  title: Text(playlist.title),
                  onTap: () {
                    // Add song to the selected playlist
                    addToPlaylist(context, playlist);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to add the song to the selected playlist
  void addToPlaylist(BuildContext context, Playlist playlist) async {
    try {
      // Gọi phương thức addToPlaylist của Song
      // await song.addToPlaylist(playlist.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm vào ${playlist.title}'),
        ),
      );
      Navigator.of(context).pop(); // Đóng AddToPlaylistScreen
    } catch (e) {
      print('Error adding song to playlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi thêm vào playlist'),
        ),
      );
    }
  }
}
