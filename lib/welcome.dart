import 'package:flutter/material.dart';
import 'package:picnic_search/barcode_search.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to BarcodeSearchScreen (assuming it's another page)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BarcodeSearchScreen()),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keeps widgets centered
            children: [
              Image.asset(
                'assets/picnic_logo.png',
                width: 300,
                height: 300,
                fit: BoxFit.cover, // Optional for better scaling
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 100, color: Colors.grey);
                },
              ),
              const SizedBox(height: 20), // Adds spacing between elements
              const Text(
                'Welcome! Press here to continue...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
