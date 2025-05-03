import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  double price; // precio de compra
  @HiveField(3)
  double salePrice; // precio de venta
  @HiveField(4)
  int quantity;
  @HiveField(5)
  String? imagePath;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
    required this.quantity,
    this.imagePath,
  });
}
