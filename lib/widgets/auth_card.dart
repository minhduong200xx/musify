import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/auth_model.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({
    Key? key,
    required this.auth,
  }) : super(key: key);

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/auth', arguments: auth);
      },
      child: Container(),
    );
  }
}
