import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylender/views/widgets/curved_navigation_bar.dart';
import 'package:moneylender/views/widgets/login/google_sign_in_button.dart';
import 'widgets/profile/profile_info.dart'; // Importando o novo widget
import '../controllers/screen_controller.dart';

class ProfilePage extends StatelessWidget {
  final User? user;
  final Map<String, dynamic> userData;
  final String profileImageUrl;
  final Function() onEditProfile;
  final GoogleSignInButton? googleSignIn;

  const ProfilePage({
    super.key,
    required this.user,
    required this.userData,
    required this.profileImageUrl,
    required this.onEditProfile,
    this.googleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final ScreenController screenController = ScreenController(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
              child: Column(
                children: [
                  ProfileInfo(
                    name: userData['name'] ?? '',
                    friendsCount: userData['friends'] != null
                        ? userData['friends'].length
                        : 0,
                  ),
                  const SizedBox(height: 30),
                  _buildOrdersContainer(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBarWidget(
        selectedIndex: 1, // Aqui pode ser 1 pois é a posição do ícone de perfil
        onIndexChanged: (index) {
          screenController.navigateToScreen(index, user!);
        },
        user: user,
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(19, 42, 101, 1.0),
      ),
    );
  }

  Widget _buildOrdersContainer(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'My Orders',
              style: TextStyle(
                color: Color.fromRGBO(39, 105, 171, 1),
                fontSize: 27,
              ),
            ),
            const Divider(thickness: 2.5),
            const SizedBox(height: 10),
            Container(
              height: height * 0.15,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
