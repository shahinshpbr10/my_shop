import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/CustomerHome/customerhome.dart';
import 'package:my_shop/views/ShopHomePage/home.dart';
import 'package:my_shop/views/auth/create_ac_customer.dart';
import 'package:my_shop/views/auth/create_ac_shopkeeper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.black,
      appBar: AppBar(
        title: const Text('Login'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Customer'),
            Tab(text: 'Shopkeeper'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CustomerLoginForm(),
          ShopkeeperLoginForm(),
        ],
      ),
    );
  }
}

class CustomerLoginForm extends StatefulWidget {
  const CustomerLoginForm({super.key});

  @override
  State<CustomerLoginForm> createState() => _CustomerLoginFormState();
}

class _CustomerLoginFormState extends State<CustomerLoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginCustomer(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String userRole = await _getUserRole(userCredential.user!.uid);

        if (userRole == 'customer') {
          // Navigate to CustomerHome screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const CustomerHome()),
          );
        } else {
          // Show an error message if the user is not a customer
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: TColors.error,
              content: Text(
                'You are not authorized to access this section.',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          );
        }
      } catch (e) {
        // If login fails, display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: TColors.error,
            content: Text('Failed to login. Please check your credentials.',
                style: Theme.of(context).textTheme.labelSmall),
          ),
        );
      }
    }
  }

  Future<String> _getUserRole(String userId) async {
    try {
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('Customerusers')
          .doc(userId)
          .get();

      if (customerSnapshot.exists) {
        return 'customer';
      } else {
        return 'other';
      }
    } catch (e) {
      print("Error getting user role: $e");
      return 'unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Image(image: AssetImage('assets/icons/shopping.png')),
              const SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have Ac?"),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return const CustomerAccountCreationScreen();
                      }));
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => _loginCustomer(context),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopkeeperLoginForm extends StatefulWidget {
  const ShopkeeperLoginForm({super.key});

  @override
  State<ShopkeeperLoginForm> createState() => _ShopkeeperLoginFormState();
}

class _ShopkeeperLoginFormState extends State<ShopkeeperLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Check the user's role from Firestore
        String userRole = await _getUserRole(userCredential.user!.uid);

        if (userRole == 'shopkeeper') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const ShopkeeperHome()),
          );
        } else if (userRole == 'customer') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: TColors.error,
              content: Text('You are not authorized to access this section.',
                  style: Theme.of(context).textTheme.labelSmall),
            ),
          );
        } else {
          print('Invalid user role');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: TColors.error,
              content: Text('You are not authorized to access this section.',
                  style: Theme.of(context).textTheme.labelSmall),
            ),
          );
        }
      } catch (e) {
        print("Error logging in: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: TColors.error,
            content: Text('Failed to login. Please check your credentials.',
                style: Theme.of(context).textTheme.labelSmall),
          ),
        );
      }
    }
  }

  Future<String> _getUserRole(String userId) async {
    try {
      DocumentSnapshot shopkeeperSnapshot = await FirebaseFirestore.instance
          .collection('shopkeepers')
          .doc(userId)
          .get();

      if (shopkeeperSnapshot.exists) {
        return 'shopkeeper';
      } else {
        DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
            .collection('customers')
            .doc(userId)
            .get();

        if (customerSnapshot.exists) {
          return 'customer';
        }
      }
    } catch (e) {
      print("Error getting user role: $e");
    }

    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Image(
                image: AssetImage('assets/icons/shopkeeper.png'),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have Ac?"),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const ShopkeeperAccountScreen()));
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
