import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/CustomerHome/tabs/dashboard_tab.dart';
import 'package:my_shop/views/CustomerHome/tabs/homeTab.dart';
import 'package:my_shop/views/CustomerHome/tabs/my_order_tab.dart';
import 'package:my_shop/views/CustomerHome/tabs/qr_tab.dart';
import 'package:my_shop/views/CustomerHome/tabs/settings_page.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({
    super.key,
  });

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const MyOrdersCustomerPage(),
    const QRScannerScreenCustomer(),
    const CustomerDashboardPage(),
    const CustomerSettingsTab()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            index: _selectedIndex,
            color: TColors.dark,
            buttonBackgroundColor: TColors.buttonPrimary,
            backgroundColor: TColors.grey,
            items: const <Widget>[
              Icon(Icons.home_rounded, size: 30),
              Icon(Icons.delivery_dining, size: 30),
              Icon(Icons.qr_code_scanner_rounded, size: 30),
              Icon(Icons.space_dashboard, size: 30),
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
