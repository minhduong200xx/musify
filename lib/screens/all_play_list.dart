import 'package:flutter/material.dart';
import '../models/playlist_model.dart';
import '../widgets/playlist_card.dart';

class AllPlaylistScreen extends StatelessWidget {
  const AllPlaylistScreen({
    Key? key,
    required this.playlists,
  }) : super(key: key);

  final List<Playlist> playlists;

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              return PlaylistCard(playlist: playlists[index]);
            },
          ),
        ),
      ),
    );
  }
}
