import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/product_service.dart';
import '../models/product.dart';

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
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Producto' : 'Crear Producto'),
      ),
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
                  child: _buildPreview(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceCtrl,
                decoration:
                    const InputDecoration(labelText: 'Precio de compra'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    double.tryParse(v!) == null ? 'Número inválido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _salePriceCtrl,
                decoration: const InputDecoration(labelText: 'Precio de venta'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    double.tryParse(v!) == null ? 'Número inválido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _qtyCtrl,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    int.tryParse(v!) == null ? 'Entero inválido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveProduct();
                  }
                },
                child: Text(isEditing ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_bytes != null) {
      return Image.memory(_bytes!, height: 150, fit: BoxFit.cover);
    } else if (_file != null) {
      return Image.file(_file!, height: 150, fit: BoxFit.cover);
    } else if (_initialImagePath != null) {
      return kIsWeb
          ? Image.network(_initialImagePath!, height: 150, fit: BoxFit.cover)
          : Image.file(File(_initialImagePath!),
              height: 150, fit: BoxFit.cover);
    } else {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.lime[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Icon(Icons.camera_alt, size: 40)),
      );
    }
  }
}
