import 'package:flutter/material.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditProfileButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Container(
            padding: const EdgeInsets.all(2),
            color: const Color.fromRGBO(19, 42, 101, 1.0),
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 16,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
