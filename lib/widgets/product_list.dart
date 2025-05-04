import 'package:flutter/material.dart';
import './product_dialog.dart';

// product_list.dart
class ProductList extends StatelessWidget {
  final Map<String, int> soldByProduct;
  final Map<String, String> nameToId;

  const ProductList({
    Key? key,
    required this.soldByProduct,
    required this.nameToId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: soldByProduct.length,
      itemBuilder: (ctx, i) {
        final entry = soldByProduct.entries.elementAt(i);
        final prodName = entry.key;
        final productId = nameToId[prodName]!;
        final colorScheme = Theme.of(context).colorScheme;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(
              Icons.inventory_2,
              color: colorScheme.secondary,
            ),
            title: Text(entry.key),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx2) => ProductDialog(
                        productId: productId,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
