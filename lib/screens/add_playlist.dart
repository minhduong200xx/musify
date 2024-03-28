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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Add to Playlist',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true, // Đặt true để căn giữa tiêu đề
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/liked-songs-64.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Liked Songs',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      Row(
                        children: [
                          Text(
                            'Playlist',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14.0),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.circle, size: 4),
                          const SizedBox(width: 5),
                          Text('29 tracks',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14.0))
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
