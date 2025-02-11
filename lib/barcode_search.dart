import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:picnic_search/qr_code%20_%20generator.dart'; // QR Code generator (ensure it's correct)

class BarcodeSearchScreen extends StatefulWidget {
  const BarcodeSearchScreen({super.key});

  @override
  _BarcodeSearchScreenState createState() => _BarcodeSearchScreenState();
}

class _BarcodeSearchScreenState extends State<BarcodeSearchScreen> {
  List<Map<String, String>> products =
      []; // List to store products from Firestore
  List<Map<String, String>> filteredProducts =
      []; // Filtered list based on search query
  TextEditingController searchController =
      TextEditingController(); // Controller for search bar

  @override
  void initState() {
    super.initState();
    loadProducts(); // Load products when screen is initialized
  }

  // Fetch products from Firestore
  Future<void> loadProducts() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db
          .collection("products")
          .get(); // Get products collection from Firestore

      setState(() {
        // Map the Firestore documents into List<Map<String, String>>
        products = querySnapshot.docs.map((doc) {
          final data = doc.data()
              as Map<String, dynamic>; // Cast to Map<String, dynamic>
          return {
            'name': data['name']?.toString() ??
                '', // Safely cast to String or default to empty string
            'barcode': data['barcode']?.toString() ??
                '', // Safely cast to String or default to empty string
          };
        }).toList();
        filteredProducts = products; // Initialize filtered list
      });
    } catch (e) {
      print("Error fetching products from Firestore: $e");
    }
  }

  // Filter products based on search query
  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['barcode']!.contains(query) || // Filter by barcode
              product['name']!
                  .toLowerCase()
                  .contains(query.toLowerCase())) // Filter by name
          .toList();
    });
  }

  // Show product dialog with QR code and barcode
  Future<void> _showProductDialog(
      BuildContext context, String name, String barcode) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: QrGenerator(barcode), // Generate QR code for barcode
              ),
              const SizedBox(height: 16),
              Text('Barcode: $barcode'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF00B0B8),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search input field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by barcode or product name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterProducts, // Filter products as user types
            ),
            const SizedBox(height: 10),
            // List of filtered products
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(filteredProducts[index]['name']!),
                      subtitle: Text(
                          'Barcode: ${filteredProducts[index]['barcode']}'),
                      onTap: () => _showProductDialog(
                        context,
                        filteredProducts[index]['name']!,
                        filteredProducts[index]['barcode']!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
