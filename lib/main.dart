import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/screens/love_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'provider/favorite_provider.dart';
import 'screens/screens.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteSongsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/song', page: () => const SongScreen()),
        GetPage(name: '/playlist', page: () => const PlaylistScreen()),
        GetPage(name: '/songlove', page: () => const SongLove())
      ],
    );
  }
}
