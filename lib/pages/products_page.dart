// pages/products_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'product_form_page.dart';
import 'update_stock_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    products = await ProductService.getProducts();
    setState(() {});
  }

  Future<void> _delete(String id) async {
    await ProductService.deleteProduct(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: products.isEmpty
            ? const Center(child: Text('No hay productos'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) {
                  final p = products[i];
                  return Card(
                    color: const Color(0xffdce2f4),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Image Thumbnail
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: p.imagePath != null
                                ? Image.file(
                                    File(p.imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image_not_supported),
                          ),
                          const SizedBox(width: 16),
                          // Info and actions
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stock: ${p.quantity}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Action buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: const Color.fromRGBO(44, 98, 255, 1.0),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductFormPage(product: p),
                                    ),
                                  );
                                  _load();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                color: const Color.fromRGBO(44, 98, 255, 1.0),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          UpdateStockPage(product: p),
                                    ),
                                  );
                                  _load();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: const Color(0xFFF9425E),
                                onPressed: () => _delete(p.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormPage()),
          );
          _load();
        },
        backgroundColor: const Color.fromRGBO(44, 98, 255, 1.0),
        child: const Icon(Icons.add),
      ),
    );
  }
}
