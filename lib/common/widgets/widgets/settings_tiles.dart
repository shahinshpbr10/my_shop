import 'package:flutter/material.dart';

class SettingsTiles extends StatelessWidget {
  final String labelText;
  final IconData? iconData;
  const SettingsTiles({
    super.key,
    required this.labelText,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Icon(iconData)
        ],
      ),
    );
  }
}
