// // screens/home_screen.dart

// import 'package:flutter/material.dart';
// import '../models/product.dart';
// import '../screens/add_product_screen.dart';
// import '../screens/edit_product_screen.dart';
// import '../widgets/product_item.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<Product> _products = [];

//   void _addProduct(Product product) {
//     setState(() {
//       _products.add(product);
//     });
//   }

//   void _editProduct(Product updatedProduct) {
//     setState(() {
//       int index = _products.indexWhere((prod) => prod.id == updatedProduct.id);
//       if (index != -1) {
//         _products[index] = updatedProduct;
//       }
//     });
//   }

//   void _updateStock(String id, int change) {
//     setState(() {
//       final product = _products.firstWhere((prod) => prod.id == id);
//       product.quantity += change;
//       if (product.quantity < 0)
//         product.quantity = 0; // No permitir stock negativo
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inventario de Tienda'),
//       ),
//       body: _products.isEmpty
//           ? Center(child: Text('No hay productos.'))
//           : ListView.builder(
//               itemCount: _products.length,
//               itemBuilder: (ctx, index) => ProductItem(
//                 product: _products[index],
//                 onEdit: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => EditProductScreen(
//                         product: _products[index],
//                         onSave: _editProduct,
//                       ),
//                     ),
//                   );
//                 },
//                 onStockChange: _updateStock,
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => AddProductScreen(onSave: _addProduct),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
