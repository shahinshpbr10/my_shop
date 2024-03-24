import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FetchHelpers {
  Future<String> fetchUserName() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return "No User Found"; // Ensure the user is logged in

    // First, attempt to fetch from the 'shopkeepers' collection
    final shopkeeperDocSnapshot = await FirebaseFirestore.instance
        .collection('shopkeepers')
        .doc(userId)
        .get();

    if (shopkeeperDocSnapshot.exists) {
      final shopkeeperData =
          shopkeeperDocSnapshot.data() as Map<String, dynamic>?;
      return shopkeeperData?['ownerName'] ?? 'Name Not Set';
    } else {
      // If not found in 'shopkeepers', attempt to fetch from the 'Customerusers' collection
      final customerDocSnapshot = await FirebaseFirestore.instance
          .collection('Customerusers')
          .doc(userId)
          .get();

      if (customerDocSnapshot.exists) {
        final customerData =
            customerDocSnapshot.data() as Map<String, dynamic>?;
        return customerData?['name'] ??
            'Name Not Set'; // Adjust the field name as per your Firestore schema
      }
    }

    return 'User Not Found in Any Collection';
  }

  Future<String> fetchUserProfilePictureUrl() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return "";

    // Attempt to fetch from the 'shopkeepers' collection first
    final shopkeeperDocSnapshot = await FirebaseFirestore.instance
        .collection('shopkeepers')
        .doc(userId)
        .get();

    if (shopkeeperDocSnapshot.exists) {
      final shopkeeperData =
          shopkeeperDocSnapshot.data() as Map<String, dynamic>?;
      if (shopkeeperData?['shopLogoUrl'] != null) {
        return shopkeeperData!['shopLogoUrl'];
      }
    }

    // If not found in 'shopkeepers', attempt to fetch from the 'Customerusers' collection
    final customerDocSnapshot = await FirebaseFirestore.instance
        .collection('Customerusers')
        .doc(userId)
        .get();

    if (customerDocSnapshot.exists) {
      final customerData = customerDocSnapshot.data() as Map<String, dynamic>?;
      if (customerData?['profileImageUrl'] != null) {
        return customerData!['profileImageUrl'];
      }
    }

    // Return a default or placeholder URL if not found in any collection
    return ""; // Consider providing a default URL here
  }
}
