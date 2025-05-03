import 'package:hive/hive.dart';
import '../models/product.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  static const boxName = 'productsBox';

  static Future<Box<Product>> _openBox() async => Hive.box<Product>(boxName);

  static Future<void> addProduct(String name, double price, double salePrice,
      int quantity, String? imagePath) async {
    final box = await _openBox();
    final id = const Uuid().v4();
    final p = Product(
        id: id,
        name: name,
        price: price,
        salePrice: salePrice,
        quantity: quantity,
        imagePath: imagePath);
    await box.put(id, p);
  }

  static Future<List<Product>> getProducts() async =>
      (await _openBox()).values.toList();

  static Future<void> updateProduct(Product product) async {
    final box = await _openBox();
    await box.put(product.id, product);
  }

  static Future<void> deleteProduct(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  static Future<void> updateStock(String id, int change) async {
    final box = await _openBox();
    final p = box.get(id);
    if (p != null) {
      p.quantity = (p.quantity + change).clamp(0, double.infinity).toInt();
      await box.put(id, p);
    }
  }
}
