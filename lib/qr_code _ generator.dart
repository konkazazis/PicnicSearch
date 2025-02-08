import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatelessWidget {
  final String qrCode;

  const QrGenerator(this.qrCode, {super.key});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrCode,
      version: QrVersions.auto,
      size: 150.0, // Increased size for better visibility
    );
  }
}
