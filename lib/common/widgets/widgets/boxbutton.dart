import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

class BoxButton extends StatelessWidget {
  final String labelText;
  const BoxButton({
    super.key,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 150,
      height: 100,
      decoration: BoxDecoration(
          color: TColors.buttonPrimary,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        labelText,
      ),
    );
  }
}
