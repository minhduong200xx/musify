import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/provider/favorite_provider.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:provider/provider.dart';
import '../models/song_model.dart';
import '../widgets/widgets.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({Key? key}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Get.arguments ?? Song.songs[0];
  bool isFavorite = false;
  bool isRepeatOne = false;
  FavoriteSongsProvider _favoriteSongsProvider = FavoriteSongsProvider();
  @override
  void initState() {
    super.initState();
    _favoriteSongsProvider =
        Provider.of<FavoriteSongsProvider>(context, listen: false);
    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse('asset:///${song.url}'),
          ),
        ],
      ),
    );
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
                              title: const Text('Thích'),
                              onTap: () {
                                _favoriteSongsProvider.toggleFavorite(song);
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text('Chia sẻ'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.music_note),
                              title: const Text('Xem bản nhạc'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Xem nghệ sĩ'),
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed('/auth');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.album),
                              title: const Text('Xem album'),
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
          Image.asset(
            song.coverUrl,
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          _MusicPlayer(
            song: song,
            seekBarDataStream: _seekBarDataStream,
            audioPlayer: audioPlayer,
            isFavorite: isFavorite,
            isRepeatOne: isRepeatOne,
            onFavoritePressed: () {
              _favoriteSongsProvider.toggleFavorite(song);
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
                      song.description,
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
