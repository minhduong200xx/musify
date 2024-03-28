import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/playlist_model.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Playlist playlist =
        ModalRoute.of(context)!.settings.arguments as Playlist;

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
          title: const Text('Playlist'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _PlaylistInformation(playlist: playlist),
                const _PlayOrShuffleSwitch(),
                _PlaylistSongs(playlist: playlist),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistSongs extends StatelessWidget {
  const _PlaylistSongs({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlist.songs.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(
            '${index + 1}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          title: Text(
            playlist.songs[index].title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
<<<<<<< HEAD
          subtitle: Text('${playlist.songs[index].singer}  '),
=======
          subtitle: Text('${playlist.songs[index].singer} '),
>>>>>>> 369f8e3a2368e64a012a2c5be8eef2922872e628
          trailing: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class _PlayOrShuffleSwitch extends StatefulWidget {
  const _PlayOrShuffleSwitch({
    Key? key,
  }) : super(key: key);

  @override
  State<_PlayOrShuffleSwitch> createState() => _PlayOrShuffleSwitchState();
}

class _PlayOrShuffleSwitchState extends State<_PlayOrShuffleSwitch> {
  bool isPlaying = false;
  bool isShuffleMode = false;
  bool isLoopMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: isPlaying
                ? const Icon(Icons.pause_circle)
                : const Icon(Icons.play_circle),
            iconSize: 60,
            color: Colors.white,
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: isShuffleMode
                ? const Icon(Icons.shuffle)
                : isLoopMode
                    ? const Icon(Icons.repeat_one)
                    : const Icon(Icons.repeat),
            iconSize: 30,
            color: Colors.white,
            onPressed: () {
              setState(() {
                if (isShuffleMode) {
                  isShuffleMode = false;
                  isLoopMode = true;
                } else if (isLoopMode) {
                  isLoopMode = false;
                } else {
                  isShuffleMode = true;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class _PlaylistInformation extends StatelessWidget {
  const _PlaylistInformation({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            playlist.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          playlist.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
