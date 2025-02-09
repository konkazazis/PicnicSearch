import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:picnic_search/barcode_search.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // Future<void> fetchData() async {
  //   try {
  //     FirebaseFirestore db = FirebaseFirestore.instance;
  //     QuerySnapshot querySnapshot = await db.collection("products").get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       for (var doc in querySnapshot.docs) {
  //         final data = doc.data() as Map<String, dynamic>?;
  //         if (data != null) {
  //           print("Document ID: ${doc.id}, Data: $data");
  //         } else {
  //           print("Document with ID: ${doc.id} has no data.");
  //         }
  //       }
  //     } else {
  //       print("No documents found in the 'products' collection.");
  //     }
  //   } catch (e) {
  //     print("Error getting documents: ${e.toString()}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            //fetchData();
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
                fit: BoxFit.cover,
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
