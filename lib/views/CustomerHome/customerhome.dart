import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/CustomerHome/managers/cart_manager.dart';
import 'package:my_shop/views/CustomerHome/tabs/dashboard_tab.dart';
import 'package:my_shop/views/CustomerHome/tabs/homeTab.dart';
import 'package:my_shop/views/CustomerHome/tabs/my_order_tab.dart';
import 'package:my_shop/views/CustomerHome/tabs/qr_tab.dart';
import 'package:my_shop/views/CustomerHome/tabs/settings_page.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const MyOrdersCustomerPage(),
      QRScannerScreenCustomer(),
      CustomerDashboardPage(
        cartManager: CartManager(),
      ),
      const CustomerSettingsTab()
    ];
  }

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
          },
        ),
      ),
    );
  }

  Future<http.Client> _getAuthenticatedHttpClient() async {
    final clientId = ClientId(
      '656678310231-u1ru6r34b7sjq2lo8vhd8kf7o1klq0pa.apps.googleusercontent.com',
      '',
    );
    final scopes = [
      'https://www.googleapis.com/auth/spreadsheets.readonly',
    ];
    final httpClient = await clientViaUserConsent(clientId, scopes, _prompt);
    return httpClient;
  }

  void _prompt(String url) {
    print('Please go to the following URL and grant access:');
    print(' => $url');
    print('');
  }
}
