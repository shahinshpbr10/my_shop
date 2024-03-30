import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shopData;

  const ShopDetailsScreen({super.key, required this.shopData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.black,
      appBar: AppBar(
        title: Text(shopData['shopName']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                shopData['shopImageUrl'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Owner: ${shopData['ownerName']}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Shop Type: ${shopData['shoptype']}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Address: ${shopData['shopAddress']}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8.0),
              // Text(
              //   'Description: ${shopData['description']}',
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(
                    'Phone: ${shopData['contactNumber']}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 8.0),
                  Text(
                    'Email: ${shopData['email']}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(shopData['websiteUrl']);
                    },
                    child: const Text('Visit Website'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _makePhoneCall(shopData['contactNumber']);
                    },
                    child: const Text('Call'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
