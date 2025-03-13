import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final String name;
  final int friendsCount;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.friendsCount,
  });

  @override
  Widget build(BuildContext context) {
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
            _buildInfoItem('Friends', friendsCount.toString()),
            _buildDivider(),
            _buildInfoItem('Pending', '1'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[700],
            fontFamily: 'Nunito',
            fontSize: 25,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color.fromRGBO(39, 105, 171, 1),
            fontFamily: 'Nunito',
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 8,
      ),
      child: Container(
        height: 50,
        width: 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey,
        ),
      ),
    );
  }
}
