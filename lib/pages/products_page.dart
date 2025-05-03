// pages/products_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import 'create_product_page.dart';
import 'edit_product_page.dart';
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
      appBar: AppBar(title: const Text('Productos')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: p.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(p.imagePath!),
                          width: 56, height: 56, fit: BoxFit.cover))
                  : null,
              title: Text(p.name),
              subtitle: Text('Stock: ${p.quantity}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditProductPage(product: p)));
                      _load();
                    }),
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UpdateStockPage(product: p)));
                      _load();
                    }),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _delete(p.id)),
              ]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CreateProductPage()));
          _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
