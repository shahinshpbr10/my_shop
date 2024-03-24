import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

class ManagmentCard extends StatelessWidget {
  const ManagmentCard({
    super.key,
    required this.imageurl,
    required this.labeltext,
  });
  final String imageurl;
  final String labeltext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: TColors.buttonPrimary,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Image.asset(
                imageurl,
                width: 40,
                height: 40,
                alignment: Alignment.center,
              ),
            )),
        const SizedBox(
          height: 5,
        ),
        Text(
          labeltext,
          style: Theme.of(context).textTheme.labelSmall,
        )
      ],
    );
  }
}
