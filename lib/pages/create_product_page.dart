import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/product_service.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});
  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  File? _file;
  Uint8List? _bytes;
  String? _base64;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final b = await picked.readAsBytes();
        setState(() {
          _bytes = b;
          _base64 = 'data:image/png;base64,${base64Encode(b)}';
        });
      } else {
        setState(() {
          _file = File(picked.path);
        });
      }
    }
  }

  Future<void> _saveProduct() async {
    final name = _nameCtrl.text;
    final price = double.tryParse(_priceCtrl.text) ?? 0.0;
    final salePrice = double.tryParse(_salePriceCtrl.text) ?? 0.0;
    final quantity = int.tryParse(_qtyCtrl.text) ?? 0;
    final imagePath = kIsWeb ? _base64 : _file?.path;

    // Llamada al servicio con los parámetros correctos
    await ProductService.addProduct(
      name,
      price,
      salePrice,
      quantity,
      imagePath,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget preview;
    if (kIsWeb && _bytes != null) {
      preview = Image.memory(_bytes!, height: 150, fit: BoxFit.cover);
    } else if (_file != null) {
      preview = Image.file(_file!, height: 150, fit: BoxFit.cover);
    } else {
      preview = Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.lime[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Icon(Icons.camera_alt, size: 40)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Producto')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: preview)),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    }),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Precio de Compra'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El precio de venta es requerido';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _salePriceCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Precio de Venta'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El precio de venta es requerido';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _qtyCtrl,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La cantidad es requerida';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingrese un número entero válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveProduct();
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          )),
    );
  }
}
