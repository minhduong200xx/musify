import 'package:flutter/material.dart';
import '../provider/favorite_provider.dart';
import 'package:provider/provider.dart';
import '../models/song_model.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteSongsProvider>(
      builder: (context, provider, _) {
        // Access filtered songs from the provider
        Set<Song> filteredSongs = provider.filteredSongs;

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
            bottomNavigationBar: const _CustomNavBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _HeaderLibrary(),
                  _ListMusicAndArtist(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderLibrary extends StatefulWidget {
  const _HeaderLibrary({
    Key? key,
  }) : super(key: key);

  @override
  _HeaderLibraryState createState() => _HeaderLibraryState();
}

class _HeaderLibraryState extends State<_HeaderLibrary> {
  Map<String, bool> buttonStates = {
    'list': false,
    'artist': false,
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1659025435463-a039676b45a0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Thư viện',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        buttonStates['list'] = !buttonStates['list']!;
                        if (buttonStates['list']!) {
                          buttonStates['artist'] = false;
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          buttonStates['list']! ? Colors.white : null,
                    ),
                    child: Text(
                      'Danh sách phát',
                      style: TextStyle(
                        color:
                            buttonStates['list']! ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        buttonStates['artist'] = !buttonStates['artist']!;
                        if (buttonStates['artist']!) {
                          buttonStates['list'] = false;
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          buttonStates['artist']! ? Colors.white : null,
                    ),
                    child: Text(
                      'Nghệ sĩ',
                      style: TextStyle(
                        color: buttonStates['artist']!
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [_ArrangeList()],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class _ListMusicAndArtist extends StatefulWidget {
  const _ListMusicAndArtist({
    Key? key,
  }) : super(key: key);

  @override
  State<_ListMusicAndArtist> createState() => _ListMusicAndArtistState();
}

class _ListMusicAndArtistState extends State<_ListMusicAndArtist> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return _FavoriteCard();
        },
      ),
    );
  }
}

class _ArrangeList extends StatefulWidget {
  const _ArrangeList({
    Key? key,
  }) : super(key: key);

  @override
  State<_ArrangeList> createState() => _ArrangeListState();
}

class _ArrangeListState extends State<_ArrangeList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
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
                            const ListTile(
                              title: Text(
                                'Sắp xếp theo',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              enabled: false,
                            ),
                            ListTile(
                              title: const Text('Gần đây'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Mới thêm gần đây'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Thứ tự chữ cái'),
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
              child: Container(
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.low_priority),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      'Gần đây',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatefulWidget {
  const _FavoriteCard({
    Key? key,
  }) : super(key: key);

  @override
  State<_FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<_FavoriteCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteSongsProvider>(
      builder: (context, provider, _) {
        // Access filtered songs from the provider
        Set<Song> filteredSongs = provider.filteredSongs;

        return Container(
          child: Row(
            children: [
              Image.asset(
                'assets/images/liked-songs-64.png',
                height: 50,
                width: 50,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bài hát ưa thích',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Text(
                        'Danh sách phát',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.circle, size: 4),
                      const SizedBox(width: 5),
                      Text('${filteredSongs.length} bài hát',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.8)))
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
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
