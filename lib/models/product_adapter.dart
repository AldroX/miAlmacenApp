import 'package:hive/hive.dart';
import 'product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final fieldIndex = reader.readByte();
      fields[fieldIndex] = reader.read();
    }
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      salePrice: fields[3] as double,
      quantity: fields[4] as int,
      imagePath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.price);
    writer.writeByte(3);
    writer.write(obj.salePrice);
    writer.writeByte(4);
    writer.write(obj.quantity);
    writer.writeByte(5);
    writer.write(obj.imagePath);
  }
}
