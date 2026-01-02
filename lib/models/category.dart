
import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}

final List<Category> defaultCategories = [
  Category(name: 'Comida', icon: Icons.fastfood, color: Colors.red),
  Category(name: 'Transporte', icon: Icons.directions_bus, color: Colors.blue),
  Category(name: 'Alojamiento', icon: Icons.hotel, color: Colors.green),
  Category(name: 'Entretenimiento', icon: Icons.movie, color: Colors.purple),
  Category(name: 'Compras', icon: Icons.shopping_cart, color: Colors.orange),
  Category(name: 'Salud', icon: Icons.healing, color: Colors.pink),
  Category(name: 'Educación', icon: Icons.school, color: Colors.brown),
  Category(name: 'Otros', icon: Icons.category, color: Colors.grey),
];
