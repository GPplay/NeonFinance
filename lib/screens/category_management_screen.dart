
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/providers/category_provider.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    Color selectedColor = category?.color ?? Colors.blue;
    IconData selectedIcon = category?.icon ?? Icons.star;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Categoría' : 'Crear Categoría'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre de la Categoría'),
                ),
                const SizedBox(height: 20),
                const Text('Color'),
                BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) => selectedColor = color,
                ),
                const SizedBox(height: 20),
                const Text('Icono'),
                SizedBox(
                  height: 200,
                  width: double.maxFinite,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                    itemCount: Icons.ac_unit_sharp.fontFamily != null ? 100 : 0,
                    itemBuilder: (context, index) {
                      final icon = IconData(Icons.ac_unit.codePoint + index, fontFamily: 'MaterialIcons');
                      return IconButton(
                        icon: Icon(icon, color: selectedIcon == icon ? Theme.of(context).colorScheme.secondary : null),
                        onPressed: () {
                          selectedIcon = icon;
                          (context as Element).markNeedsBuild();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final categoryNotifier = ref.read(categoryProvider.notifier);
                  if (isEditing) {
                    final updatedCategory = Category(
                      name: nameController.text,
                      color: selectedColor,
                      icon: selectedIcon,
                    );
                    categoryNotifier.updateCategory(category.name, updatedCategory);
                  } else {
                    final newCategory = Category(
                      name: nameController.text,
                      color: selectedColor,
                      icon: selectedIcon,
                    );
                    categoryNotifier.addCategory(newCategory);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Guardar' : 'Crear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Categorías'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: Icon(category.icon, color: category.color),
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showCategoryDialog(context, ref, category: category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(categoryProvider.notifier).deleteCategory(category.name);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
