import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_app_ui/models/auth_model.dart';
import 'package:flutter_music_app_ui/models/song_model.dart';
import 'package:flutter_music_app_ui/provider/favorite_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Auth.findArtistByName('Artist Name 1');
    final artistSongs =
        Song.songs.where((song) => song.artist == 'Artist Name 1').toList();

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _BackgroundImgAuth(
                  bgUrl: auth?.bgUrl ?? '', artistName: auth?.name ?? ''),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                            '${auth?.listenCount ?? 0} N người nghe hàng tháng'),
                      ],
                    ),
                    Row(
                      children: [
                        _FollowAndMore(),
                        Spacer(),
                        _PlayOrShuffleSwitch(),
                      ],
                    ),
                    _PopularOfAuth(artistSongs: artistSongs),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundImgAuth extends StatefulWidget {
  const _BackgroundImgAuth({
    Key? key,
    required this.bgUrl,
    required this.artistName, // Thêm trường dữ liệu để nhận tên nghệ sĩ
  }) : super(key: key);

  final String bgUrl;
  final String artistName; // Định nghĩa trường dữ liệu để nhận tên nghệ sĩ

  @override
  State<_BackgroundImgAuth> createState() => _BackgroundImgAuthState();
}

class _BackgroundImgAuthState extends State<_BackgroundImgAuth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            widget.bgUrl,
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
          Positioned(
            top: 8,
            left: 5,
            child: IconButton(
              iconSize: 20,
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 15,
            left: 20,
            child: Text(
              widget.artistName, // Sử dụng tên nghệ sĩ từ trường dữ liệu
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
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
            icon: isShuffleMode
                ? const Icon(Icons.shuffle)
                : isLoopMode
                    ? const Icon(Icons.repeat_one)
                    : const Icon(Icons.repeat),
            iconSize: 25,
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
          const SizedBox(width: 5),
          IconButton(
            icon: isPlaying
                ? const Icon(Icons.pause_circle)
                : const Icon(Icons.play_circle),
            iconSize: 50,
            color: Colors.white,
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _FollowAndMore extends StatefulWidget {
  const _FollowAndMore({
    Key? key,
  }) : super(key: key);

  @override
  State<_FollowAndMore> createState() => _FollowAndMoreState();
}

class _FollowAndMoreState extends State<_FollowAndMore> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) {
                  return BorderSide(
                    color: isFollowing ? Colors.white : Colors.white,
                    width: 1,
                  );
                },
              ),
            ),
            onPressed: () {
              setState(() {
                isFollowing = !isFollowing;
              });
            },
            child: Text(
              isFollowing ? 'Theo dõi' : 'Đang theo dõi',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
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
                            title: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/auth.jpg'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Phương Ly',
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 0,
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Icon(Icons.person_add),
                            title: const Text('Theo dõi'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.do_not_disturb_on),
                            title:
                                const Text('Không phát nhạc của nghệ sĩ này'),
                            onTap: () {
                              Navigator.pop(context);
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
                            leading: const Icon(Icons.report),
                            title: const Text('Báo cáo'),
                            onTap: () {
                              Navigator.pop(context);
                              Get.toNamed('/auth');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularOfAuth extends StatefulWidget {
  const _PopularOfAuth({
    Key? key,
    required this.artistSongs,
  }) : super(key: key);

  final List<Song> artistSongs;

  @override
  State<_PopularOfAuth> createState() => _PopularOfAuthState();
}

class _PopularOfAuthState extends State<_PopularOfAuth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Phổ biến',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.artistSongs.length,
            itemBuilder: ((context, index) {
              return SongCard(song: widget.artistSongs[index]);
            }),
          ),
        ],
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    final isFavorite = Provider.of<FavoriteSongsProvider>(context)
        .favoriteSongs
        .contains(song);
    return InkWell(
      onTap: () {
        Get.toNamed('/song', arguments: song);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 75,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      song.coverUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          song.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${song.listens} ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isFavorite)
                    IconButton(
                      onPressed: () {
                        final provider = Provider.of<FavoriteSongsProvider>(
                            context,
                            listen: false);
                        provider.removeFromFavorites(song);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.deepPurple[400],
                      ),
                    ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
