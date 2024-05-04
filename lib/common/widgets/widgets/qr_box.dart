import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePrintScreen extends StatelessWidget {
  final String qrCodeData;

  const QrCodePrintScreen({Key? key, required this.qrCodeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(data: qrCodeData))));
  }
}
