import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            _BackgroundImgAuth(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('990 N người nghe hàng tháng'),
                    ],
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Row(
                    children: [
                      _FollowAndMore(),
                      Spacer(),
                      _PlayOrShuffleSwitch(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BackgroundImgAuth extends StatefulWidget {
  const _BackgroundImgAuth({
    Key? key,
  }) : super(key: key);

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
            'assets/images/auth.jpg',
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
              onPressed: () {},
            ),
          ),
          const Positioned(
            bottom: 15,
            left: 20,
            child: Text(
              'Phương Ly',
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
          const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _PopularOfAuth extends StatefulWidget {
  const _PopularOfAuth({
    Key? key,
  }) : super(key: key);

  @override
  State<_PopularOfAuth> createState() => _PopularOfAuthState();
}

class _PopularOfAuthState extends State<_PopularOfAuth> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
