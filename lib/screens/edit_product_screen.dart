// // screens/edit_product_screen.dart

// import 'package:flutter/material.dart';
// import '../models/product.dart';

// class EditProductScreen extends StatefulWidget {
//   final Product product;
//   final Function(Product) onSave;

//   EditProductScreen({required this.product, required this.onSave});

//   @override
//   _EditProductScreenState createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String _name;
//   late double _price;
//   late int _quantity;

//   @override
//   void initState() {
//     super.initState();
//     _name = widget.product.name;
//     _price = widget.product.price;
//     _quantity = widget.product.quantity;
//   }

//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final updatedProduct = Product(
//         id: widget.product.id,
//         name: _name,
//         price: _price,
//         quantity: _quantity,
//       );

//       widget.onSave(updatedProduct);
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Editar Producto')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: _name,
//                 decoration: InputDecoration(labelText: 'Nombre'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Ingrese un nombre' : null,
//                 onSaved: (value) => _name = value!,
//               ),
//               TextFormField(
//                 initialValue: _price.toString(),
//                 decoration: InputDecoration(labelText: 'Precio'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Ingrese un precio' : null,
//                 onSaved: (value) => _price = double.parse(value!),
//               ),
//               TextFormField(
//                 initialValue: _quantity.toString(),
//                 decoration: InputDecoration(labelText: 'Cantidad'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Ingrese una cantidad' : null,
//                 onSaved: (value) => _quantity = int.parse(value!),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 child: Text('Actualizar'),
//                 onPressed: _submit,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
