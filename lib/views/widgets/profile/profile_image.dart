import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback onSelectImage;

  const ProfileImage({
    super.key,
    required this.profileImageUrl,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          radius: 75,
          backgroundImage: profileImageUrl != null
              ? NetworkImage(profileImageUrl!)
              : const AssetImage('assets/images/user.png') as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.add_a_photo, color: Colors.white),
            onPressed: onSelectImage,
          ),
        ),
      ],
    );
  }
}