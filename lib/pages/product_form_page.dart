import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/product_service.dart';
import '../models/product.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

class ProductFormPage extends StatefulWidget {
  final Product? product; // si es nulo -> crear; si no -> editar

  const ProductFormPage({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  File? _file;
  Uint8List? _bytes;
  String? _base64;
  String? _initialImagePath; // ruta o URL inicial
  final _picker = ImagePicker();

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final p = widget.product!;
      _nameCtrl.text = p.name;
      _priceCtrl.text = p.price.toString();
      _salePriceCtrl.text = p.salePrice.toString();
      _qtyCtrl.text = p.quantity.toString();
      _initialImagePath = p.imagePath;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _salePriceCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final b = await picked.readAsBytes();
        setState(() {
          _bytes = b;
          _base64 = 'data:image/png;base64,${base64Encode(b)}';
          _initialImagePath = null;
        });
      } else {
        setState(() {
          _file = File(picked.path);
          _initialImagePath = null;
        });
      }
    }
  }

  Future<void> _saveProduct() async {
    final name = _nameCtrl.text;
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final salePrice = double.tryParse(_salePriceCtrl.text) ?? 0;
    final quantity = int.tryParse(_qtyCtrl.text) ?? 0;
    final imagePath =
        _file != null ? _file!.path : (_base64 ?? _initialImagePath);

    if (isEditing) {
      // Construir objeto actualizado y pasarlo al servicio
      final updatedProduct = Product(
        id: widget.product!.id,
        name: name,
        price: price,
        salePrice: salePrice,
        quantity: quantity,
        imagePath: imagePath ?? '',
      );
      await ProductService.updateProduct(updatedProduct);
    } else {
      await ProductService.addProduct(
        name,
        price,
        salePrice,
        quantity,
        imagePath,
      );
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isEditing ? 'Editar Producto' : 'Crear Producto',
          style: const TextStyle(color: Color(0xFF364c84)),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Complete los datos del producto',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF95B1EE)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF757575),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xFF95B1EE),
                        ),
                        child: const Center(
                          child: Icon(Icons.camera_alt,
                              size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Color(0xFF364c84))),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? 'Campo requerido' : null,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Precio de compra',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Color(0xFF364c84))),
                          ),
                          validator: (v) => double.tryParse(v!) == null
                              ? 'Número inválido'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _salePriceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Precio de venta',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Color(0xFF364c84))),
                          ),
                          validator: (v) => double.tryParse(v!) == null
                              ? 'Número inválido'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _qtyCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cantidad',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Color(0xFF364c84))),
                          ),
                          validator: (v) => int.tryParse(v!) == null
                              ? 'Entero inválido'
                              : null,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveProduct();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF364c84),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          child: Text(isEditing ? 'Actualizar' : 'Guardar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
