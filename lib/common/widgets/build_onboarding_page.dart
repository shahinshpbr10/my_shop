import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_shop/constants/color.dart';

Widget buildPage({
  required String imageUrl,
  required String title,
  required String subtitle,
}) =>
    Container(
      color: TColors.dark,
      child: Column(
        children: [
          SvgPicture.asset(
            imageUrl,
            width: 400,
            height: 400,
          ),
          Text(
            title,
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              subtitle,
            ),
          )
        ],
      ),
    );
