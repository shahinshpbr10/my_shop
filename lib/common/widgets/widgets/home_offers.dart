import 'package:iconsax/iconsax.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/dimension/dimens.dart';

import 'package:flutter/material.dart';

class UpcomingScheduleCard extends StatelessWidget {
  const UpcomingScheduleCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.baseSize * 2),
      decoration: BoxDecoration(
        color: TColors.dark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          //doctor details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppDimensions.hSpace(1),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Image Mobiles",
                      ),
                      Text(
                        "Mobile Shop",
                      ),
                    ],
                  )
                ],
              ),
              // call button
              const CircleAvatar(
                radius: 17,
                foregroundColor: Colors.black,
                backgroundColor: Color(0xffF5F5ED),
                // backgroundColor: Color(0xff9DAE9B),
                child: Icon(
                  Iconsax.call,
                  size: 15,
                ),
              )
            ],
          ),
          AppDimensions.vSpace(2),
          // date and time
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.baseSize * 2),
            decoration: BoxDecoration(
              color: TColors.primary,
              //color: AppColors.bluegreen,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Iconsax.calendar,
                      color: Colors.black,
                      size: 15,
                    ),
                    AppDimensions.hSpace(1),
                    const Text(
                      "23 October 2023",
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Iconsax.clock,
                      color: Colors.black,
                      size: 15,
                    ),
                    AppDimensions.hSpace(1),
                    const Text(
                      "12.35 - 13.45",
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
