import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.headingText,
  });
  final String headingText;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ),
        const Spacer(),
        Text(
          headingText,
        ),
        const Spacer(),
      ],
    );
  }
}
