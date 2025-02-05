import 'package:flutter/material.dart';

void main() {
  runApp(BarcodeSearchApp());
}

class BarcodeSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barcode Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BarcodeSearchScreen(),
    );
  }
}

class BarcodeSearchScreen extends StatefulWidget {
  const BarcodeSearchScreen({super.key});

  @override
  _BarcodeSearchScreenState createState() => _BarcodeSearchScreenState();
}

class _BarcodeSearchScreenState extends State<BarcodeSearchScreen> {
  final List<Map<String, String>> products = [
    {'barcode': '123456', 'name': 'Bundmohren 1 Bund'},
    {'barcode': '234567', 'name': 'Bio Trauben hell 400g'},
    {'barcode': '345678', 'name': 'Lauchzwiebeln 1 Bund'},
    {'barcode': '456789', 'name': 'Gut&Gunstig Mohren 2kg'},
    {'barcode': '567890', 'name': 'PN Bio Kiwi Gold 3st'},
  ];

  List<Map<String, String>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
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

  Future<void> _dialogBuilder(
      BuildContext context, String name, String barcode) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Text('Barcode: $barcode'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Barcode Search')),
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
                      onTap: () => _dialogBuilder(
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
