import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.title,
    required this.action,
    required this.onViewMorePressed, // Thêm tham số hàm để xử lý sự kiện khi người dùng nhấn vào "View More"
  }) : super(key: key);

  final String title;
  final String action;
  final VoidCallback
      onViewMorePressed; // Thêm hàm xử lý sự kiện khi người dùng nhấn vào "View More"

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed:
              onViewMorePressed, // Gọi hàm xử lý sự kiện khi người dùng nhấn vào "View More"
          child: Text(
            action,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
