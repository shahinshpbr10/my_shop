import 'package:flutter/material.dart';
import 'package:my_shop/views/ShopHomePage/tabs/homeTab.dart';

class UserTileSettings extends StatelessWidget {
  const UserTileSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
                  backgroundImage:
                      AssetImage("assets/images/profile.png"), // Default image
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
          const SizedBox(width: 10),
          FutureBuilder<String>(
            future: fetchHelpers.fetchUserName(), // Fetch the user name
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
          )
        ],
      ),
    );
  }
}
