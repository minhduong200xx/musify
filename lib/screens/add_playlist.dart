import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/screens/playlist_screen.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';

class AddToPlaylistScreen extends StatelessWidget {
  const AddToPlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: FutureBuilder<List<Playlist>>(
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
                    // addToPlaylist(context, playlist);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
