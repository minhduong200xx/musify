import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/widgets/global_audio.dart';

class FloatingNowPlayingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayer = GlobalAudioPlayer.audioPlayer;

    return Container(
      // Thiết kế thanh hiện đang phát ở đây
      // Ví dụ:
      height: 100,
      color: Colors.black.withOpacity(0.5),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              audioPlayer
                  .play(); // Gọi phương thức play từ trình phát âm thanh toàn cục
            },
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              audioPlayer
                  .pause(); // Gọi phương thức pause từ trình phát âm thanh toàn cục
            },
          ),
          // Thêm các thông tin khác như tên bài hát, nghệ sĩ, ảnh album, vv.
        ],
      ),
    );
  }
}
