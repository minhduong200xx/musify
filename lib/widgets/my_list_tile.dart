import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap; // Thay Null Function() bằng VoidCallback

  const MyListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap, // Sử dụng VoidCallback thay vì Null Function()
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(text, style: TextStyle(color: Colors.white)),
        onTap: onTap, // Gắn onTap vào ListTile
      ),
    );
  }
}
