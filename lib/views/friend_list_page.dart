import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:moneylender/views/widgets/friends/friend_request_list.dart';
import 'package:moneylender/views/widgets/friends/friends_list.dart';
import '../controllers/friend_controller.dart';
import '../models/friend_model.dart';

class FriendListPage extends StatefulWidget {
  final String userId;

  const FriendListPage({super.key, required this.userId});

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  late FriendController _friendController;
  List<String> friends = [];
  List<String> friendRequests = [];
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    final friendModel = FriendModel(widget.userId);
    _friendController = FriendController(context, friendModel);
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    friends = await _friendController.friendModel.getFriends();
    friendRequests = await _friendController.friendModel.getFriendRequests();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      body: _buildBody(),
      floatingActionButton: _buildSpeedDial(),
      bottomNavigationBar: _buildCurvedNavigationBar(),
    );
  }

  Widget _buildBody() {
    if (friendRequests.isNotEmpty) {
      return FriendRequestList(
        friendRequests: friendRequests,
        onAccept: _friendController.handleAcceptFriendRequest,
        onDecline: _friendController.handleDeclineFriendRequest,
      );
    } else if (friends.isNotEmpty) {
      return FriendsList(
        friends: friends,
        onRemove: _friendController.handleRemoveFriend,
      );
    } else {
      return const Center(child: Text('Nenhum amigo ainda.'));
    }
  }

  SpeedDial _buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      backgroundColor: Colors.green,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.group_add),
          label: 'Adicionar Amigo',
          onTap: () {
            // Navegar para tela de adicionar amigo
          },
        ),
      ],
    );
  }

  CurvedNavigationBar _buildCurvedNavigationBar() {
    return CurvedNavigationBar(
      color: const Color.fromRGBO(16, 31, 78, 1.0),
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: const Color.fromRGBO(7, 123, 50, 1.0),
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      index: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        // Lógica de navegação
      },
      items: const <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.search, size: 30),
        Icon(Icons.people, size: 30),
        Icon(Icons.account_circle, size: 30),
        Icon(Icons.settings, size: 30),
      ],
    );
  }
}
