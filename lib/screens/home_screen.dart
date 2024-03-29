import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/screens/now_playing_bar.dart';
import 'package:flutter_music_app_ui/screens/screens.dart';
import 'package:flutter_music_app_ui/widgets/my_drawer.dart';
import 'package:get/get.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
      future: fetchSongs(),
      builder: (context, songSnapshot) {
        if (songSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder widget while loading
        }
        if (songSnapshot.hasError) {
          return Text('Error: ${songSnapshot.error}'); // Error handling
        }
        List<Song> songs = songSnapshot.data ?? []; // Extracted song list

        return FutureBuilder<List<Playlist>>(
          future: Playlist.createPlaylists(),
          builder: (context, playlistSnapshot) {
            if (playlistSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Placeholder widget while loading
            }
            if (playlistSnapshot.hasError) {
              return Text('Error: ${playlistSnapshot.error}'); // Error handling
            }
            List<Playlist> playlists =
                playlistSnapshot.data ?? []; // Extracted playlist list

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
                appBar: const _CustomAppBar(),
                drawer: MyDrawer(),
                bottomNavigationBar: const _CustomNavBar(),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _DiscoverMusic(),
                          _TrendingMusic(songs: songs),
                          _PlaylistMusic(playlists: playlists),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PlaylistMusic extends StatelessWidget {
  const _PlaylistMusic({
    Key? key,
    required this.playlists,
  }) : super(key: key);

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SectionHeader(title: 'Playlists'),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: playlists.length,
            itemBuilder: ((context, index) {
              return PlaylistCard(playlist: playlists[index]);
            }),
          ),
        ],
      ),
    );
  }
}

class _TrendingMusic extends StatelessWidget {
  const _TrendingMusic({
    Key? key,
    required this.songs,
  }) : super(key: key);

  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: 'Trending Music'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.27,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongCard(song: songs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverMusic extends StatefulWidget {
  const _DiscoverMusic({Key? key}) : super(key: key);

  @override
  _DiscoverMusicState createState() => _DiscoverMusicState();
}

class _DiscoverMusicState extends State<_DiscoverMusic> {
  TextEditingController _searchController = TextEditingController();
  List<Song> _searchResults = [];

  Future<List<Song>> searchSongs(String query) async {
    // Get reference to the Firestore collection
    CollectionReference songsRef =
        FirebaseFirestore.instance.collection('songs');

    // Query the Firestore collection for songs containing the query
    QuerySnapshot querySnapshot = await songsRef.get();

    List<Song> results = querySnapshot.docs
        .map((doc) => Song.fromFirestore(doc))
        .where((song) => song.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final String _name;
    final user = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Welcome ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                '${user?.email ?? ""}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Enjoy your favorite music',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _searchController,
            onChanged: (value) async {
              // Call the search function when text changes
              List<Song> songs = await searchSongs(value);
              setState(() {
                _searchResults = songs;
              });
            },
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey.shade400),
              suffixIcon: ElevatedButton(
                onPressed: () {
                  _showSearchResultsPopup(context);
                },
                child: Icon(
                  Icons.search,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchResultsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Color.fromARGB(142, 0, 0, 0),
            dialogTheme: DialogTheme(
              backgroundColor: Color.fromARGB(223, 255, 255, 255),
            ),
          ),
          child: AlertDialog(
            title: Text('Search Results',
                style: TextStyle(color: Color.fromARGB(255, 89, 4, 129))),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                          const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        _searchResults[index].coverImageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(_searchResults[index].title),
                    subtitle: Text(_searchResults[index].singer),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_circle,
                              size: 30, color: Colors.deepPurple),
                          onPressed: () {
                            Get.toNamed('/song',
                                arguments: _searchResults[index]);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    Text('Close', style: TextStyle(color: Colors.deepPurple)),
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

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: TextButton(
            // Use TextButton for clickable behavior
            onPressed: () {
              // Navigate to login/register screen (using your chosen navigation method)
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => user != null
                        ? ProfileScreen()
                        : LoginPage()), // Replace with your login screen widget
              );
            },
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://cdn4.iconfinder.com/data/icons/music-ui-solid-24px/24/user_account_profile-2-512.png',
              ), // Adjust text color as needed
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
