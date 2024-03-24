import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_shop/constants/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShopkeeperAccountScreen extends StatefulWidget {
  const ShopkeeperAccountScreen({super.key});

  @override
  _ShopkeeperAccountScreenState createState() =>
      _ShopkeeperAccountScreenState();
}

class _ShopkeeperAccountScreenState extends State<ShopkeeperAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _shopName = '';
  String _shopAddress = '';
  String _contactNumber = '';
  String _email = '';
  String _password = '';
  File? _shopImage;
  File? _shopLogo;
  Position? _shopLocation;
  bool viewPassword = true;
  final String _userRole = 'shopkeeper';

  Future<void> _pickImageShop(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _shopImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickLogoShop(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _shopLogo = File(pickedImage.path);
      });
    }
  }

  Future<void> _getShopLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        setState(() {
          _shopLocation = position;
        });
      } else {
        print('Location permission denied');
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        String? imageUrl;
        if (_shopImage != null) {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('shop_images/${userCredential.user!.uid}.jpg');
          UploadTask uploadTask = storageReference.putFile(_shopImage!);
          TaskSnapshot taskSnapshot = await uploadTask;
          imageUrl = await taskSnapshot.ref.getDownloadURL();
        }

        String? logoUrl;
        if (_shopLogo != null) {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('shop_logos/${userCredential.user!.uid}.jpg');
          UploadTask uploadTask = storageReference.putFile(_shopLogo!);
          TaskSnapshot taskSnapshot = await uploadTask;
          logoUrl = await taskSnapshot.ref.getDownloadURL();
        }

        if (_userRole == 'shopkeeper') {
          await FirebaseFirestore.instance
              .collection('shopkeepers')
              .doc(userCredential.user!.uid)
              .set({
            'shopName': _shopName,
            'shopAddress': _shopAddress,
            'contactNumber': _contactNumber,
            'email': _email,
            'shopImageUrl': imageUrl,
            'shopLogoUrl': logoUrl,
            'location': _shopLocation != null
                ? {
                    'latitude': _shopLocation!.latitude,
                    'longitude': _shopLocation!.longitude
                  }
                : null,
          });
        } else if (_userRole == 'customer') {
          return;
        }

        // Navigate or show a success message
        print("Account created successfully!");
      } catch (e) {
        print("Error creating account: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Shopkeeper Account',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add Shop Image ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Select Image Source'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            _pickImageShop(ImageSource.camera);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo_library),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            _pickImageShop(ImageSource.gallery);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: TColors.primary),
                              ),
                              child: _shopImage != null
                                  ? Image.file(
                                      _shopImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add Shop Logo ',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Select Image Source'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            _pickLogoShop(ImageSource.camera);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo_library),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            _pickLogoShop(ImageSource.gallery);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: TColors.primary),
                              ),
                              child: _shopLogo != null
                                  ? Image.file(
                                      _shopLogo!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Shop Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                    labelText: 'Owner Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter owner name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _shopName = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                    labelText: 'Shop Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your shop name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _shopName = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                    labelText: 'Shop Address',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your shop address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _shopAddress = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  obscureText: viewPassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Iconsax.eye),
                      onPressed: () {
                        setState(() {
                          viewPassword = !viewPassword;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                    labelText: 'Contact Number',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _contactNumber = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _getShopLocation,
                    child: const Text('Get Shop Location'),
                  ),
                ),
                const SizedBox(height: 18.0),
                _shopLocation != null
                    ? Center(
                        child: Text(
                          'Latitude: ${_shopLocation!.latitude}\nLongitude: ${_shopLocation!.longitude}',
                        ),
                      )
                    : const Center(child: Text('Shop location not available')),
                const SizedBox(height: 16.0),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                          height: 16.0), // Add some spacing between the buttons
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Check if the image and location are not null
                            if (_shopImage != null &&
                                _shopLocation != null &&
                                _shopLogo != null) {
                              // Proceed to create account
                              _createAccount();
                              Navigator.pop(context);
                            } else {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please complete all Sections'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
