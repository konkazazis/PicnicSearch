import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:picnic_search/qr_code%20_%20generator.dart'; // Ensure correct import
import 'package:picnic_search/welcome.dart';

class BarcodeSearchScreen extends StatefulWidget {
  const BarcodeSearchScreen({super.key});

  @override
  _BarcodeSearchScreenState createState() => _BarcodeSearchScreenState();
}

class _BarcodeSearchScreenState extends State<BarcodeSearchScreen> {
  List<Map<String, String>> products = [];
  List<Map<String, String>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    String jsonString = await rootBundle.loadString('assets/products.json');
    List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      products =
          jsonResponse.map((data) => Map<String, String>.from(data)).toList();
      filteredProducts = products;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['barcode']!.contains(query) ||
              product['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
                width: 150, // Ensure it has a defined width
                height: 150, // Ensure it has a defined height
                child: QrGenerator(barcode),
              ),
              SizedBox(height: 16),
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
        title: Text('Product Search'),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF00C4CC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by barcode or product name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterProducts,
            ),
            SizedBox(height: 10),
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
