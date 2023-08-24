import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart'; // Importação do pacote de ícones
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/edit_profile_screen.dart';
import 'package:moneylender/views/friend_list_screen.dart';
import 'package:moneylender/views/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  final GoogleSignIn googleSignIn;

  const ProfileScreen({
    Key? key,
    required this.user,
    required this.googleSignIn,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profileImageUrl;
  String defaultProfileImageUrl = 'assets/images/user.png';
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl();
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildProfileHeader(),
                  const SizedBox(height: 30),
                  _buildOrdersContainer(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(19, 42, 101, 1.0),
      ),
    );
  }

  Widget _buildProfileHeader() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.43,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double innerHeight = constraints.maxHeight;
          double innerWidth = constraints.maxWidth;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: innerHeight * 0.72,
                  width: innerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.user!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          var name = userData['name'] ?? '';
                          var friendsCount = userData['friends'] != null
                              ? userData['friends'].length
                              : 0;

                          return Column(
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Color.fromRGBO(39, 105, 171, 1),
                                  fontFamily: 'Nunito',
                                  fontSize: 37,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Friends',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'Nunito',
                                          fontSize: 25,
                                        ),
                                      ),
                                      Text(
                                        friendsCount.toString(),
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(39, 105, 171, 1),
                                          fontFamily: 'Nunito',
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 8,
                                    ),
                                    child: Container(
                                      height: 50,
                                      width: 3,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Pending',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontFamily: 'Nunito',
                                          fontSize: 25,
                                        ),
                                      ),
                                      const Text(
                                        '1',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(39, 105, 171, 1),
                                          fontFamily: 'Nunito',
                                          fontSize: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 110,
                right: 20,
                child: widget.user?.providerData[0].providerId == 'google.com'
                    ? Icon(
                        AntDesign.google,
                        color: Colors.grey[700],
                        size: 30,
                      )
                    : () {
                        print(
                            "Provider ID: ${widget.user?.providerData[0].providerId}");
                        return SizedBox();
                      }(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: profileImageUrl != null
                            ? CircleAvatar(
                                radius: innerWidth * 0.22,
                                backgroundImage: NetworkImage(profileImageUrl!),
                              )
                            : CircleAvatar(
                                radius: innerWidth * 0.22,
                                backgroundImage:
                                    AssetImage(defaultProfileImageUrl),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _navigateToEditProfile,
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
                                  onPressed: _navigateToEditProfile,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          user: widget.user,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        _fetchProfileImageUrl();
      });
    }
  }

  Widget _buildOrdersContainer() {
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

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      color: const Color(0xFFCBB26A),
      buttonBackgroundColor: const Color(0xFFCBB26A),
      height: 50,
      animationDuration: const Duration(milliseconds: 300),
      index: _selectedIndex,
      onTap: _onNavigationTap,
      items: const <Widget>[
        Icon(Icons.home, color: Color.fromRGBO(19, 42, 101, 1.0)),
        Icon(Icons.person, color: Color.fromRGBO(19, 42, 101, 1.0)),
        Icon(Icons.people, color: Color.fromRGBO(19, 42, 101, 1.0)),
      ],
    );
  }

  Future<void> _fetchProfileImageUrl() async {
    if (widget.user != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${widget.user?.uid}.jpg');

      try {
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          profileImageUrl = imageUrl;
        });
      } catch (e) {
        print("Error fetching profile image URL: $e");
        if (widget.user?.photoURL != null) {
          setState(() {
            profileImageUrl = widget.user!.photoURL;
          });
        } else {
          setState(() {
            profileImageUrl = defaultProfileImageUrl;
          });
        }
      }
    }
  }

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _navigateToHome();
      } else if (index == 2) {
        _navigateToFriendList();
      }
    });
  }

  void _navigateToFriendList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendListScreen(userId: widget.user!.uid),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomeScreen(user: widget.user, googleSignIn: widget.googleSignIn),
      ),
    );
  }
}
