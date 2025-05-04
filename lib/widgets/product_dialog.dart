import 'package:flutter/material.dart';
import '../services/product_service.dart';
import 'package:mialmacen/models/product.dart';

// product_dialog.dart
class ProductDialog extends StatelessWidget {
  final String productId;

  const ProductDialog({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: ProductService.getProductById(productId),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('No se pudo cargar el producto: ${snapshot.error}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          );
        }
        final prod = snapshot.data!;
        return AlertDialog(
          title: Text('Detalles de ${prod.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Precio unitario: \$${prod.price.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Precio de venta: \$${prod.salePrice.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Cantidad en stock: ${prod.quantity}'),
              const SizedBox(height: 8),
              Text(
                'Ganancia total: \$${((prod.salePrice - prod.price) * prod.quantity).toStringAsFixed(2)}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
