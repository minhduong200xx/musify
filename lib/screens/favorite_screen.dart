import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../models/song_model.dart';
import '../provider/favorite_provider.dart';

class FavoriteSong extends StatelessWidget {
  final String userId;

  const FavoriteSong({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<_DiscoverLoveMusicState> _discoverLoveMusicKey =
        GlobalKey<_DiscoverLoveMusicState>();

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Consumer<FavoriteSongsProvider>(
                builder: (context, favoriteProvider, _) {
                  final favoriteSongs = favoriteProvider.favoriteSongs.toList();
                  return _DiscoverLoveMusic(
                    key: _discoverLoveMusicKey,
                    favoriteSongs: favoriteSongs,
                    favoriteProvider: favoriteProvider,
                  );
                },
              ),
              const SizedBox(height: 10),
              const _PlayOrShuffleSwitch(),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<FavoriteSongsProvider>(
                  builder: (context, favoriteProvider, _) {
                    final user = FirebaseAuth.instance.currentUser;
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                      } else {
                        favoriteProvider.fetchFavoriteSongs(user.uid);
                      }
                    });
                    final favoriteSongs = user != null
                        ? favoriteProvider.favoriteSongs.toList()
                        : null;
                    return ListView.builder(
                      itemCount:
                          favoriteSongs != null ? favoriteSongs.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            favoriteSongs != null
                                ? ListTile(
                                    tileColor: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        favoriteSongs[index].coverImageUrl,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(favoriteSongs[index].title),
                                    subtitle: Text(favoriteSongs[index].singer),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.deepPurple,
                                          ),
                                          onPressed: () {
                                            Provider.of<FavoriteSongsProvider>(
                                                    context,
                                                    listen: false)
                                                .toggleFavorite(
                                              favoriteSongs[index],
                                              userId,
                                            );
                                            _DiscoverLoveMusicState?
                                                _discoverLoveMusicState =
                                                _discoverLoveMusicKey
                                                    .currentState;
                                            if (_discoverLoveMusicState !=
                                                null) {
                                              _discoverLoveMusicState
                                                  ._updateFilteredSongs();
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.play_circle,
                                              size: 30,
                                              color: Colors.deepPurple),
                                          onPressed: () {
                                            Get.toNamed('/song',
                                                arguments:
                                                    favoriteSongs[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Text("No favorite songs founded"),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoverLoveMusic extends StatefulWidget {
  final List<Song> favoriteSongs;
  final FavoriteSongsProvider favoriteProvider;

  const _DiscoverLoveMusic({
    Key? key,
    required this.favoriteSongs,
    required this.favoriteProvider,
  }) : super(key: key);

  @override
  _DiscoverLoveMusicState createState() => _DiscoverLoveMusicState();
}

class _DiscoverLoveMusicState extends State<_DiscoverLoveMusic> {
  late TextEditingController _searchController;
  late List<Song> _filteredSongs;
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredSongs = widget.favoriteSongs;
  }

  void _filterSongs(String query) {
    setState(() {
      _filteredSongs = widget.favoriteSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = song.artist.toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) || artist.contains(searchLower);
      }).toList();
    });
  }

  void _updateFilteredSongs() {
    setState(() {
      _filteredSongs = widget.favoriteProvider.filteredSongs.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: _filterSongs,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      hintText: 'Search',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<int>(
                offset: const Offset(0, 50),
                color: Colors.deepPurple[400],
                icon: const Icon(Icons.filter_list, color: Colors.white),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      'Sắp xếp theo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Text('Tiêu đề',
                            style: TextStyle(
                              color: selectedValue == 1
                                  ? Colors.green
                                  : Colors.white,
                            )),
                        const Spacer(),
                        if (selectedValue == 1)
                          const Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Text('Nghệ sĩ',
                            style: TextStyle(
                              color: selectedValue == 2
                                  ? Colors.green
                                  : Colors.white,
                            )),
                        const Spacer(),
                        if (selectedValue == 2)
                          const Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      children: [
                        Text('Album',
                            style: TextStyle(
                              color: selectedValue == 3
                                  ? Colors.green
                                  : Colors.white,
                            )),
                        Spacer(),
                        if (selectedValue == 3)
                          const Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 4,
                    child: Row(
                      children: [
                        Text('Mới thêm gần đây',
                            style: TextStyle(
                              color: selectedValue == 4
                                  ? Colors.green
                                  : Colors.white,
                            )),
                        const Spacer(),
                        if (selectedValue == 4)
                          const Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),
                ],
                onSelected: (int value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Bài hát ưa thích',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          Text(
            '${_filteredSongs.length} bài hát',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
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

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> routeNames = ['/', '/favorite', '/song', 'library'];
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.deepPurple.shade800,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_outline),
          label: 'Play',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index < routeNames.length) {
          Navigator.pushNamed(context, routeNames[index]);
        }
      },
    );
  }
}
