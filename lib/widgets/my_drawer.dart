import 'package:flutter/material.dart';
import 'package:flutter_music_app_ui/widgets/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    final List<String> routeNames = ['/', '/profile'];
    return Drawer(
      backgroundColor: Colors.deepPurple,
      child: Column(
        children: [
          // header
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 44,
            ),
          ),
          MyListTile(
            icon: Icons.account_circle,
            text: 'HỒ SƠ',
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          MyListTile(
            icon: Icons.logout,
            text: "ĐĂNG XUẤT",
            onTap: () {
              // Thực hiện hành động khi nút "ĐĂNG XUẤT" được nhấp
            },
          ),
          MyListTile(
            icon: Icons.support_agent,
            text: "HỖ TRỢ",
            onTap: () {
              // Thực hiện hành động khi nút "HỖ TRỢ" được nhấp
            },
          ),
          MyListTile(
            icon: Icons.verified_user,
            text: "QUYỀN RIÊNG TƯ",
            onTap: () {
              // Thực hiện hành động khi nút "QUYỀN RIÊNG TƯ" được nhấp
            },
          ),
          MyListTile(
            icon: Icons.gavel,
            text: "ĐIỀU KHOẢN",
            onTap: () {
              // Thực hiện hành động khi nút "ĐIỀU KHOẢN" được nhấp
            },
          ),
        ],
      ),
    );
  }
}
