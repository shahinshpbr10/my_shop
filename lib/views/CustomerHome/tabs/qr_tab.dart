import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreenCustomer extends StatefulWidget {
  const QRScannerScreenCustomer({super.key});

  @override
  _QRScannerScreenCustomerState createState() =>
      _QRScannerScreenCustomerState();
}

class _QRScannerScreenCustomerState extends State<QRScannerScreenCustomer> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: TColors.primary,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data
      print("Scanned QR Code: $scanData");
      // Add your logic here to process the scanned data
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
