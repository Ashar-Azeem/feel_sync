import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomAvatar extends StatelessWidget {
  final double radius;
  final String? url;
  const CustomAvatar({super.key, required this.radius, this.url});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius.w * 2,
        height: radius.w * 2,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 34, 42, 55),
          shape: BoxShape.circle,
        ),
        child: url == null
            ? Image.asset(
                'assets/blankprofile.png',
              )
            : Image.network(
                url!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
