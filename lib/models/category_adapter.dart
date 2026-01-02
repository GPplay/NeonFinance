
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/category.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1; // Unique ID for the adapter

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      name: fields[0] as String,
      icon: IconData(fields[1] as int, fontFamily: 'MaterialIcons'),
      color: Color(fields[2] as int),
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.icon.codePoint)
      ..writeByte(2)
      ..write(obj.color.toARGB32());
  }
}
