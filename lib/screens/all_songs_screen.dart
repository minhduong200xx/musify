import 'package:flutter/material.dart';
import 'package:musify/models/song_model.dart';
import 'package:get/get.dart';

class AllSongsScreen extends StatelessWidget {
  const AllSongsScreen({Key? key}) : super(key: key);

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
          child: FutureBuilder<List<Song>>(
            future: fetchSongs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final songs = snapshot.data!;
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(song.coverImageUrl),
                          ),
                          title: Text(
                            song.title.length > 20
                                ? '${song.title.substring(0, 20)}...'
                                : song.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            song.singer.length > 20
                                ? '${song.singer.substring(0, 20)}...'
                                : song.singer,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.play_circle,
                                  size: 30,
                                  color: Colors.deepPurple,
                                ),
                                onPressed: () {
                                  // Handle play button press
                                  Get.toNamed('/song', arguments: song);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle ListTile tap
                          },
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('No songs available'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
