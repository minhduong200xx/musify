import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../models/song_model.dart';
import '../provider/favorite_provider.dart';

class FavoriteSong extends StatelessWidget {
  const FavoriteSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteSongs =
        Provider.of<FavoriteSongsProvider>(context).favoriteSongs.toList();

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
              _DiscoverLoveMusic(favoriteSongs: favoriteSongs),
              const SizedBox(height: 30),
              const _PlayOrShuffleSwitch(),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteSongs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              favoriteSongs[index].coverUrl,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(favoriteSongs[index].title),
                          subtitle: Text(favoriteSongs[index].description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.deepPurple,
                                ),
                                onPressed: () {
                                  Provider.of<FavoriteSongsProvider>(context,
                                          listen: false)
                                      .removeFromFavorites(
                                          favoriteSongs[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.play_circle,
                                    size: 30, color: Colors.deepPurple),
                                onPressed: () {
                                  Get.toNamed('/song',
                                      arguments: favoriteSongs[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
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

  const _DiscoverLoveMusic({
    Key? key,
    required this.favoriteSongs,
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
                    style: TextStyle(color: Colors.white),
                    onChanged: _filterSongs,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      hintText: 'Search',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
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
                  PopupMenuItem<int>(
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
                        Spacer(),
                        if (selectedValue == 1)
                          Icon(Icons.check, color: Colors.green),
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
                        Spacer(),
                        if (selectedValue == 2)
                          Icon(Icons.check, color: Colors.green),
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
                          Icon(Icons.check, color: Colors.green),
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
                        Spacer(),
                        if (selectedValue == 4)
                          Icon(Icons.check, color: Colors.green),
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
            style: Theme.of(context).textTheme.headline6!.copyWith(
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
  bool isPlay = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          isPlay = !isPlay;
        });
      },
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: isPlay ? 0 : width * 0.45,
              child: Container(
                height: 50,
                width: width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Play',
                          style: TextStyle(
                            color: isPlay ? Colors.white : Colors.deepPurple,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.play_circle,
                        color: isPlay ? Colors.white : Colors.deepPurple,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Shuffle',
                          style: TextStyle(
                            color: isPlay ? Colors.deepPurple : Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.shuffle,
                        color: isPlay ? Colors.deepPurple : Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
