// widgets/product_item.dart

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final Function(String, int) onStockChange;

  ProductItem({
    required this.product,
    required this.onEdit,
    required this.onStockChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(
            'Precio: \$${product.price.toStringAsFixed(2)}  -  Stock: ${product.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => onStockChange(product.id, -1),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onStockChange(product.id, 1),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
