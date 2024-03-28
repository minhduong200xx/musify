import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/provider/favorite_provider.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../widgets/widgets.dart';
import 'add_playlist.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({Key? key}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Get.arguments ?? fetchSongs();
  bool isFavorite = false;
  bool isRepeatOne = false;
  FavoriteSongsProvider _favoriteSongsProvider = FavoriteSongsProvider();
  late String userId;

  @override
  void initState() {
    super.initState();
    _favoriteSongsProvider =
        Provider.of<FavoriteSongsProvider>(context, listen: false);
    audioPlayer.setUrl('${song.audioUrl}');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(
          position,
          duration ?? Duration.zero,
        );
      });

  @override
  Widget build(BuildContext context) {
    bool isFavorite = Provider.of<FavoriteSongsProvider>(context)
        .favoriteSongs
        .contains(song);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.favorite,
                                  color: isFavorite
                                      ? Colors.deepPurple[200]
                                      : Colors.black),
                              title: const Text('Like'),
                              onTap: () {
                                _favoriteSongsProvider.toggleFavorite(
                                    song, userId);
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.add),
                              title: const Text('Thêm vào danh sách khác'),
                              onTap: () {
                                // Open AddToPlaylistScreen when "Thêm vào danh sách khác" is pressed
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddToPlaylistScreen(song: song),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text('Share'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.music_note),
                              title: const Text('View lyric'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('View author'),
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed('/auth');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.album),
                              title: const Text('View album'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            '${song.coverImageUrl}',
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
            // loadingBuilder: (BuildContext context, Widget child,
            //     ImageChunkEvent? loadingProgress) {
            //   if (loadingProgress == null) {
            //     return child;
            //   } else {
            //     return Center(
            //       child: CircularProgressIndicator(
            //         value: loadingProgress.expectedTotalBytes != null
            //             ? loadingProgress.cumulativeBytesLoaded /
            //                 loadingProgress.expectedTotalBytes!
            //             : null,
            //       ),
            //     );
            //   }
            // },
            // errorBuilder: (BuildContext context, Object exception,
            //     StackTrace? stackTrace) {
            //   return Text('Failed to load image');
            // },
          ),
          const _BackgroundFilter(),
          _MusicPlayer(
            song: song,
            seekBarDataStream: _seekBarDataStream,
            audioPlayer: audioPlayer,
            isFavorite: isFavorite,
            isRepeatOne: isRepeatOne,
            onFavoritePressed: () {
              _favoriteSongsProvider.toggleFavorite(song, userId);
            },
            onRepeatPressed: () {
              setState(() {
                isRepeatOne = !isRepeatOne;
              });

              audioPlayer
                  .setLoopMode(isRepeatOne ? LoopMode.one : LoopMode.off);
            },
          ),
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    Key? key,
    required this.song,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
    required this.isFavorite,
    required this.isRepeatOne,
    required this.onFavoritePressed,
    required this.onRepeatPressed,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Song song;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final bool isFavorite;
  final bool isRepeatOne;
  final VoidCallback onFavoritePressed;
  final VoidCallback onRepeatPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 50.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Căn chỉnh về phía trái
                children: [
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Text(
                      song.singer,
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: onFavoritePressed,
                  child: Consumer<FavoriteSongsProvider>(
                    builder: (context, provider, _) {
                      final isFavorite = provider.favoriteSongs.contains(song);
                      return Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          StreamBuilder<SeekBarData>(
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek,
              );
            },
          ),
          Row(
            children: [
              const Icon(
                Icons.shuffle,
                color: Colors.white,
                size: 30,
              ),
              const Spacer(),
              PlayerButtons(audioPlayer: audioPlayer),
              const Spacer(),
              GestureDetector(
                onTap: onRepeatPressed,
                child: Icon(
                  isRepeatOne ? Icons.repeat_one : Icons.repeat,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800,
            ],
          ),
        ),
      ),
    );
  }
}
