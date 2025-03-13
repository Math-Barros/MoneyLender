import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/screen_controller.dart';
import 'widgets/curved_navigation_bar.dart';
import 'widgets/home/event_button.dart';
import 'widgets/home/event_list.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late BuildContext _context; // Adicionando variável para armazenar o contexto

  @override
  void initState() {
    super.initState();
    _context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      body: Column(
        children: [
          const SizedBox(height: 50.0),
          const Text(
            'Meus Eventos',
            style: TextStyle(
              color: Color(0xFFCBB26A),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2.5),
          Expanded(
            child: EventList(user: widget.user),
          ),
        ],
      ),
      floatingActionButton: EventButton(user: widget.user),
      bottomNavigationBar: CurvedNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onIndexChanged: _onNavigationBarTap,
        user: widget.user,
      ),
    );
  }

  void _onNavigationBarTap(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        ScreenController(context).navigateToProfile(context, widget.user!);
      } else if (index == 2) {
        ScreenController(context).navigateToFriendList(widget.user!);
      }
    });
  }
}
