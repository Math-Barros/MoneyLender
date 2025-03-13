import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final double innerWidth;

  const ProfileAvatar({
    super.key,
    required this.profileImageUrl,
    required this.innerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: profileImageUrl != null
          ? CircleAvatar(
              radius: innerWidth * 0.22,
              backgroundImage: NetworkImage(profileImageUrl!),
            )
          : CircleAvatar(
              radius: innerWidth * 0.22,
              backgroundImage: const AssetImage('assets/images/user.png'),
            ),
    );
  }
}
