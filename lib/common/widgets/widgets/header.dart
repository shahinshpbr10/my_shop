import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_shop/common/widgets/widgets/home_offers.dart';
import 'package:my_shop/common/widgets/widgets/search_box.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/dimension/dimens.dart';

class TopCardSection extends StatelessWidget {
  const TopCardSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.baseSize * 2.5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: TColors.primary,
        //color: Color(0xff9DAE9B),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimensions.vSpace(3),
          appbar(),
          AppDimensions.vSpace(3),
          Text("Browse,Click,and Enjoy!",
              style: Theme.of(context).textTheme.headlineMedium),
          AppDimensions.vSpace(3),
          const SearchBox(),
          AppDimensions.vSpace(3),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Discover Exclusive Shopper's Delights!",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ],
              ),
              AppDimensions.vSpace(2),
              const UpcomingScheduleCard()
            ],
          ),
          AppDimensions.vSpace(1),
        ],
      ),
    );
  }

  Row appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            AppDimensions.hSpace(1),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good morning",
                ),
                Text(
                  "Peerangi Shibil",
                ),
              ],
            )
          ],
        ),
        const CircleAvatar(
          radius: 20,
          foregroundColor: Colors.black,
          backgroundColor: Color(0xffF5F5ED),
          //backgroundColor: Color(0xff9DAE9B),
          child: Icon(
            Iconsax.notification,
            size: 20,
          ),
        )
      ],
    );
  }
}
