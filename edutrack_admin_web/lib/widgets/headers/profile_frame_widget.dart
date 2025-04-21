import 'package:flutter/material.dart';

class ProfileFrame extends StatelessWidget {
  final String imageUrl;

  const ProfileFrame({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 60,
        height: 60,
        color: Colors.grey.shade200,
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
