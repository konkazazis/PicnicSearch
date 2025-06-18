import 'package:flutter/material.dart';

class QrScanner extends StatelessWidget {
  const QrScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Qr Scan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        backgroundColor: const Color(0xFF00B0B8),
        elevation: 4,
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
