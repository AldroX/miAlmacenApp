// // screens/add_product_screen.dart
// import ''
// import 'package:flutter/material.dart';
// import '../models/product.dart';
// import 'package:uuid/uuid.dart';

// class AddProductScreen extends StatefulWidget {
//   final Function(Product) onSave;

//   AddProductScreen({required this.onSave});

//   @override
//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _name = '';
//   double _price = 0;
//   int _quantity = 0;

//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final newProduct = Product(
//         id: Uuid().v4(), // genera un id único
//         name: _name,
//         price: _price,
//         quantity: _quantity,
//       );

//       widget.onSave(newProduct);
//       Navigator.of(context).pop(); // volver atrás
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Agregar Producto')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Nombre'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Ingrese un nombre' : null,
//                 onSaved: (value) => _name = value!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Precio'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Ingrese un precio' : null,
//                 onSaved: (value) => _price = double.parse(value!),
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Cantidad'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Ingrese una cantidad' : null,
//                 onSaved: (value) => _quantity = int.parse(value!),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 child: Text('Guardar'),
//                 onPressed: _submit,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
