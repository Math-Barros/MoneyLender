import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylender/services/profile_service.dart';
import 'package:moneylender/views/add_event_page.dart';
import 'package:moneylender/views/event_details_page.dart';
import 'package:moneylender/views/friend_list_page.dart';

import '../views/profile_page.dart';

class ScreenController {
  final BuildContext context;

  ScreenController(this.context);

  void navigateToAddEvent(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventPage(user: user),
      ),
    );
  }

  void navigateToFriendList(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendListPage(userId: user.uid),
      ),
    );
  }

  void navigateToEventDetails(User user, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(eventId: eventId, userId: user.uid),
      ),
    );
  }

  void navigateToProfile(BuildContext context, User user) async {
    final ProfileService profileService = ProfileService(user: user);

    final Map<String, dynamic> userData = await profileService.fetchUserData();
    final String profileImageUrl = await profileService.fetchProfileImageUrl();

    if (Navigator.canPop(context)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: user,
            userData: userData,
            profileImageUrl: profileImageUrl,
            onEditProfile: () {
              // Adicione aqui a lógica para editar o perfil
            },
            googleSignIn: null,
          ),
        ),
      );
    }
  }

  void navigateToScreen(int index, User user) {
    switch (index) {
      case 0:
        navigateToAddEvent(user);
        break;
      case 1:
        navigateToProfile(context, user);
        break;
      case 2:
        navigateToFriendList(user);
        break;
      default:
        break;
    }
  }
}
