import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/auth/loginpage.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

class Shopkeeper {
  final String name;
  final int reviewCount;
  final String imageUrl; // Add imageUrl property
  final bool isVerified; // Add isVerified property
  final String shoptype;

  Shopkeeper({
    required this.name,
    required this.shoptype,
    required this.reviewCount,
    required this.imageUrl,
    required this.isVerified,
  });
}

class Category {
  final int id;
  final String text;

  Category(this.id, this.text);
}

class FindShopkeeper extends StatefulWidget {
  const FindShopkeeper({super.key});

  @override
  State<FindShopkeeper> createState() => _FindShopkeeperState();
}

class _FindShopkeeperState extends State<FindShopkeeper> {
  List<Category> categories = [
    Category(1, "View Bills"),
    Category(2, "View Credits"),
    Category(3, "Payment History"),
  ];

  int selectedIndex = 0;

  List<Shopkeeper> shopkeepers = [
    Shopkeeper(
      name: "Basheerkka Kada",
      shoptype: "Fancy",
      reviewCount: 20,
      imageUrl: 'assets/images/profile.png',
      isVerified: true,
    ),
    Shopkeeper(
      name: "Mohammed Kada",
      shoptype: "supermarket",
      reviewCount: 15,
      imageUrl: 'assets/images/profile.png',
      isVerified: false,
    ),
    Shopkeeper(
      name: "Abdulla Kada",
      shoptype: "supermarket",
      reviewCount: 30,
      imageUrl: 'assets/images/profile.png',
      isVerified: true,
    ),
    Shopkeeper(
      name: "Basheerkka Kada",
      shoptype: "supermarket",
      reviewCount: 25,
      imageUrl: 'assets/images/profile.png',
      isVerified: true,
    ),
    Shopkeeper(
      name: "Basheerkka Kada",
      shoptype: "Fish shop",
      reviewCount: 35,
      imageUrl: 'assets/images/profile.png',
      isVerified: false,
    ),
    Shopkeeper(
      name: "Basheerkka Kada",
      shoptype: "palachark",
      reviewCount: 10,
      imageUrl: 'assets/images/profile.png',
      isVerified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'What Do You Need?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'See all',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categories.length,
              (index) => categoryButton(
                categories[index],
                index,
              ),
            ).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          alignment: Alignment.bottomLeft,
          child: const Text(
            'Shops Nearby',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: shopkeepers
              .map(
                (e) => ShopkeeperWidget(
                  shopkeeper: e,
                  onTap: () {
                    // Navigate to ShopDetailsPage when a shop is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShopDetailsPage(
                          shopLocation: 'perinthalmanna',
                          shopPhoneNumber: "626262626",
                          shopName: e.name,
                          imageUrl: e.imageUrl,
                          isVerified: e.isVerified,
                          reviewCount: e.reviewCount,
                          availableProducts: getAvailableProductsForShop(e),
                        ),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget categoryButton(
    Category category,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(TColors.darkerGrey),
        ),
        onPressed: () {
          // Handle category button tap
          setState(() {
            selectedIndex = index;
          });

          // Add logic based on the selected category
          switch (category.id) {
            case 1:
              // Handle View Bills category tap
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen(); // Replace with your actual View Bills page
                  },
                ),
              );
              break;
            case 2:
              // Handle View Credits category tap
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen(); // Replace with your actual View Credits page
                  },
                ),
              );
              break;
            case 3:
              // Handle Payment History category tap
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen(); // Replace with your actual Payment History page
                  },
                ),
              );
              break;
          }
        },
        child: Text(
          category.text,
          style: const TextStyle(
            color: TColors.white,
          ),
        ),
      ),
    );
  }

  List<Product> getAvailableProductsForShop(Shopkeeper shopkeeper) {
    // Replace this with your logic to fetch products for the selected shop
    // For simplicity, returning dummy data here
    return [
      Product(
          name: 'Product 1',
          price: 20,
          imageUrl: "assets/images/sammy-line-searching.gif"),
      Product(
          name: 'Product 2',
          price: 30,
          imageUrl: "assets/images/sammy-line-searching.gif"),
      Product(
          name: 'Product 3',
          price: 25,
          imageUrl: "assets/images/sammy-line-searching.gif"),
    ];
  }
}

class ShopkeeperWidget extends StatelessWidget {
  final Shopkeeper shopkeeper;
  final VoidCallback onTap;

  const ShopkeeperWidget({super.key, required this.shopkeeper, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: TColors.darkerGrey,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(shopkeeper.imageUrl),
              ),
              if (shopkeeper.isVerified)
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
            ],
          ),
          title: Text(shopkeeper.name),
          subtitle: Column(
            children: [
              Row(
                children: [Text(shopkeeper.shoptype)],
              ),
              Row(
                children: [
                  StarRating(reviewCount: shopkeeper.reviewCount),
                ],
              ),
              Row(
                children: [Text('(${shopkeeper.reviewCount} Reviews)')],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShopDetailsPage extends StatelessWidget {
  final String shopName;
  final String imageUrl;
  final bool isVerified;
  final int reviewCount;
  final List<Product> availableProducts;
  final String shopLocation; // Added shop location
  final String shopPhoneNumber; // Added shop phone number

  const ShopDetailsPage({super.key, 
    required this.shopName,
    required this.imageUrl,
    required this.isVerified,
    required this.reviewCount,
    required this.availableProducts,
    required this.shopLocation,
    required this.shopPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.dark,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 8),
            Text(shopName),
            if (isVerified)
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.verified,
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
      body: Container(
        color: TColors.dark,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imageUrl,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Shop Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                StarRating(reviewCount: reviewCount),
                const SizedBox(width: 8),
                Text('($reviewCount Reviews)'),
              ],
            ),
            const Divider(),
            const Text(
              'Location:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              shopLocation, // Replace with the actual shop location
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Phone Number:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              shopPhoneNumber, // Replace with the actual shop phone number
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            const Text(
              'Available Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: availableProducts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: SizedBox(
                      width: 100,
                      height: 70,
                      child: Image.asset("assets/images/profile.png"),
                    ),
                    title: Text(availableProducts[index].name),
                    subtitle:
                        Text('\$${availableProducts[index].price.toString()}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Added ${availableProducts[index].name} to cart'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int reviewCount;

  const StarRating({super.key, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < reviewCount ? Icons.star : Icons.star_border,
          color: Colors.amber,
        ),
      ),
    );
  }
}
