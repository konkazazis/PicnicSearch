import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picnic_search/qr_code%20_%20generator.dart';

class BarcodeSearchScreen extends StatefulWidget {
  const BarcodeSearchScreen({super.key});

  @override
  _BarcodeSearchScreenState createState() => _BarcodeSearchScreenState();
}

class _BarcodeSearchScreenState extends State<BarcodeSearchScreen> {
  List<Map<String, String>> products = [];
  List<Map<String, String>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() {
      _isLoading = true; // Show loader
    });
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db.collection("products").get();

      setState(() {
        products = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name']?.toString() ?? '',
            'barcode': data['barcode']?.toString() ?? '',
          };
        }).toList();
        filteredProducts = products;
      });
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  Future<void> _updateProduct(
      String id, String newName, String newBarcode) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).update({
        'name': newName,
        'barcode': newBarcode,
      });
      await loadProducts(); // Refresh product list
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
      await loadProducts(); // Refresh list after deletion
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> _addProduct(String name, String barcode) async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': name,
        'barcode': barcode,
      });
      await loadProducts(); // Refresh list after adding
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  Future<void> _showEditDialog(BuildContext context,
      {String? id, String? name, String? barcode}) {
    TextEditingController nameController =
        TextEditingController(text: name ?? '');
    TextEditingController barcodeController =
        TextEditingController(text: barcode ?? '');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Product' : 'Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: barcodeController,
                decoration: const InputDecoration(labelText: 'Barcode'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (id == null) {
                  await _addProduct(
                      nameController.text, barcodeController.text);
                } else {
                  await _updateProduct(
                      id, nameController.text, barcodeController.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () async {
                await _deleteProduct(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                width: 200,
                height: 200,
                child: QrGenerator(barcode),
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
        foregroundColor: Colors.white,
        title: const Text(
          'Product Search',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF00B0B8),
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white,),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                focusColor: Colors.black,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Search by barcode or product name',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterProducts,
            ),
            const SizedBox(height: 10),
            _isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueGrey,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6), // Adds more space around content
                            title: Text(filteredProducts[index]['name']!),
                            subtitle: Text(
                                'Barcode: ${filteredProducts[index]['barcode']}'),
                            onTap: () => _showProductDialog(
                              context,
                              filteredProducts[index]['name']!,
                              filteredProducts[index]['barcode']!,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueGrey),
                                  onPressed: () => _showEditDialog(
                                    context,
                                    id: filteredProducts[index]['id']!,
                                    name: filteredProducts[index]['name']!,
                                    barcode: filteredProducts[index]
                                        ['barcode']!,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _showDeleteDialog(
                                    context,
                                    filteredProducts[index]['id']!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00B0B8),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showEditDialog(context), // Opens Add Product dialog
      ),
    );
  }
}
