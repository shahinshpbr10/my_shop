import 'package:flutter/material.dart';

class UserTileSettings extends StatelessWidget {
  const UserTileSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.png"),
          ),
          SizedBox(width: 10),
          Text(
            'Username',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
