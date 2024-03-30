import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_shop/Backend/fetchhelpers.dart';
import 'package:my_shop/common/widgets/widgets/home_offers.dart';
import 'package:my_shop/common/widgets/widgets/search_box.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/dimension/dimens.dart';
import 'package:my_shop/views/ShopHomePage/tabs/homeTab.dart';

class TopCardSection extends StatelessWidget {
  const TopCardSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FetchHelpers fetchHelpers = FetchHelpers();
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
          // Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Row(
          //           children: [
          //             Text("Discover Exclusive Shopper's Delights!",
          //                 style: Theme.of(context).textTheme.headlineMedium),
          //           ],
          //         ),
          //       ],
          //     ),
          //     AppDimensions.vSpace(2),
          //     const UpcomingScheduleCard()
          //   ],
          // ),
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
            FutureBuilder<String>(
              future: fetchHelpers.fetchUserProfilePictureUrl(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the data, show a placeholder
                  return const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        "assets/images/profile.png"), // Placeholder image
                  );
                } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                  // In case of an error or if the URL is empty, show a default avatar
                  return const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                        "assets/images/profile.png"), // Default image
                  );
                } else {
                  // When data is fetched successfully, show the profile picture
                  return CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        snapshot.data!), // Fetched profile picture URL
                    backgroundColor: Colors.transparent,
                  );
                }
              },
            ),
            AppDimensions.hSpace(1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Good morning",
                  style: TextStyle(fontSize: 30),
                ),
                FutureBuilder<String>(
                  future: fetchHelpers.fetchUserName(), // Fetch the user name
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                          "Loading..."); // Optionally handle loading state
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}"); // Error handling
                    } else {
                      return Text(
                        snapshot.data!,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium, // Display the fetched name
                        // Add text style if needed
                      );
                    }
                  },
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
