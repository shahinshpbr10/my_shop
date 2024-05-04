import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/ShopHomePage/tabs/accounting_tab.dart';
import 'package:my_shop/views/ShopHomePage/tabs/customer.dart';
import 'package:my_shop/views/ShopHomePage/tabs/homeTab.dart';
import 'package:my_shop/views/ShopHomePage/tabs/qr_tab.dart';
import 'package:my_shop/views/ShopHomePage/tabs/settings_tab.dart';

class ShopkeeperHome extends StatefulWidget {
  const ShopkeeperHome({
    super.key,
  });

  @override
  State<ShopkeeperHome> createState() => _ShopkeeperHomeState();
}

class _ShopkeeperHomeState extends State<ShopkeeperHome> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeTab(),
    const CustomerTab(),
    AddProductScreen(),
    const AccountingTab(),
    const SettingsTab()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            index: _selectedIndex,
            color: TColors.black,
            buttonBackgroundColor: TColors.buttonPrimary,
            backgroundColor: TColors.buttonSecondary,
            items: const <Widget>[
              Icon(Icons.home_rounded, size: 30),
              Icon(Icons.people_alt, size: 30),
              Icon(Icons.add, size: 30),
              Icon(Icons.sticky_note_2_outlined, size: 30),
              Icon(Icons.settings_outlined, size: 30)
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            }),
      ),
    );
  }
}
