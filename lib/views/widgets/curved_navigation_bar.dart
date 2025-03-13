import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;
  final User? user;

  const CurvedNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      color: const Color(0xFFCBB26A),
      buttonBackgroundColor: const Color(0xFFCBB26A),
      height: 50,
      animationDuration: const Duration(milliseconds: 300),
      index: selectedIndex,
      onTap: onIndexChanged,
      items: const <Widget>[
        Icon(Icons.home, color: Color.fromRGBO(19, 42, 101, 1.0)),
        Icon(Icons.person, color: Color.fromRGBO(19, 42, 101, 1.0)),
        Icon(Icons.people, color: Color.fromRGBO(19, 42, 101, 1.0)),
      ],
    );
  }
}
