import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/CustomerHome/pages/shop_detail_page.dart';

class ShopsNearCustomer extends StatefulWidget {
  const ShopsNearCustomer({super.key});

  @override
  State<ShopsNearCustomer> createState() => _ShopsNearCustomerState();
}

class _ShopsNearCustomerState extends State<ShopsNearCustomer> {
  Stream<List<DocumentSnapshot>>? shopsStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> _favoriteShopIds = <String>{};

  @override
  void initState() {
    super.initState();
    _getAllShops();
    _getFavoriteShopIds();
  }

  Future<void> _getAllShops() async {
    shopsStream = _firestore
        .collection('shopkeepers')
        .snapshots()
        .map((event) => event.docs);

    setState(() {});
  }

  Future<void> _getFavoriteShopIds() async {
    final favorites = await _firestore.collection('favorite').get();
    _favoriteShopIds.addAll(favorites.docs.map((doc) => doc.id));
    setState(() {});
  }

  Future<void> _toggleFavorite(
      String shopId, Map<String, dynamic> shopData) async {
    if (_favoriteShopIds.contains(shopId)) {
      // Remove from favorites
      await _firestore.collection('favorite').doc(shopId).delete();
      _favoriteShopIds.remove(shopId);
    } else {
      // Add to favorites
      await _firestore.collection('favorite').doc(shopId).set(shopData);
      _favoriteShopIds.add(shopId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return shopsStream != null
        ? StreamBuilder<List<DocumentSnapshot>>(
            stream: shopsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final shops = snapshot.data!;
                return ListView.separated(
                  itemCount: shops.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    final data = shop.data() as Map<String, dynamic>;
                    final shopId = shop.id;
                    final isFavorite = _favoriteShopIds.contains(shopId);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopDetailsScreen(
                              shopData: data,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColors.darkerGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image(
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data['shopImageUrl']),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data['shopName'],
                                      style: const TextStyle(fontSize: 35),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Owner:'),
                                    Text(data['ownerName']),
                                  ],
                                ),
                                Text(data['shoptype']),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                _toggleFavorite(shopId, data);
                              },
                              icon: Icon(
                                Iconsax.heart,
                                color: isFavorite ? Colors.red : null,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('favorite').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data!.docs;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite =
                    favorites[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(favorite['shopName']),
                  subtitle: Text(favorite['shoptype']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Remove the favorite from the collection
                      firestore
                          .collection('favorite')
                          .doc(favorites[index].id)
                          .delete();
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
