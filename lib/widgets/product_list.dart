import 'package:flutter/material.dart';
import '/services/product_service.dart';

class ProductList extends StatefulWidget {
  final Map<String, int> soldByProduct;
  final Map<String, String> nameToId;

  const ProductList({
    Key? key,
    required this.soldByProduct,
    required this.nameToId,
  }) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future<void> _viewProduct(String productId) async {
    try {
      // 1) Llamada asíncrona
      final product = await ProductService.getProductById(productId);

      // 2) Comprueba que el widget siga en árbol
      if (!mounted) return;

      // 3) Ahora sí: abres el diálogo con el context del State
      showDialog(
        context: context,
        builder: (ctx2) => AlertDialog(
          title: Text('Detalles de ${product.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Precio unitario: \$${product.price.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text(
                  'Precio de venta: \$${product.salePrice.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Cantidad en stock: ${product.quantity}'),
              const SizedBox(height: 8),
              Text(
                'Ganancia total: \$${((product.salePrice - product.price) * product.quantity).toStringAsFixed(2)}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx2).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar el producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.soldByProduct.length,
      itemBuilder: (_, i) {
        final entry = widget.soldByProduct.entries.elementAt(i);
        final prodName = entry.key;
        final String? productId = widget.nameToId[prodName];
        print('Buscando ID para "$prodName": ${widget.nameToId[prodName]}');
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(Icons.inventory_2, color: colorScheme.secondary),
            title: Text(prodName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${entry.value}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: (productId != null && productId.isNotEmpty)
                      ? () => _viewProduct(productId)
                      : null,
                  color: colorScheme.secondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
