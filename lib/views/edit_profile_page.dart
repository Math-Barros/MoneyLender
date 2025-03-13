import 'package:flutter/material.dart';
import 'package:moneylender/controllers/edit_profile_controller.dart';
import 'package:moneylender/views/widgets/profile/profile_image.dart';
import 'package:moneylender/views/widgets/profile/profile_name_field.dart';

class EditProfilePage extends StatefulWidget {
  final EditProfileController controller;

  const EditProfilePage({super.key, required this.controller});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchProfileData().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileImage(
              profileImageUrl: widget.controller.profileImageUrl,
              onSelectImage: () async {
                await widget.controller.selectProfileImage();
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            NameField(
              initialValue: widget.controller.displayName ?? '',
              onNameChanged: (value) {
                widget.controller.displayName = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await widget.controller.updateProfile(
                  widget.controller.displayName ?? '',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              },
              child: const Text('Update Profile'),
            ),
            if (widget.controller.isEmailUser)
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await widget.controller.changePassword();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset email sent')),
                  );
                },
                child: const Text('Change Password'),
              ),
          ],
        ),
      ),
    );
  }
}
