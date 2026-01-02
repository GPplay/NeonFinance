// ignore: unused_import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:state_notifier/state_notifier.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/repositories/local_storage_repository.dart';

// 1. Define the StateNotifier
class CategoryNotifier extends StateNotifier<List<Category>> {
  final LocalStorageRepository _repository;

  CategoryNotifier(this._repository) : super(_repository.getCategories());

  void addCategory(Category category) {
    _repository.saveCategory(category);
    state = _repository.getCategories(); // Refresh state
  }

  void updateCategory(String oldName, Category newCategory) {
    _repository.updateCategory(oldName, newCategory);
    state = _repository.getCategories(); // Refresh state
  }

  void deleteCategory(String name) {
    _repository.deleteCategory(name);
    state = _repository.getCategories(); // Refresh state
  }
}

// 2. Define the StateNotifierProvider
final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  // For this provider, we need an instance of LocalStorageRepository.
  // We can create a simple provider for it, or instantiate it directly if it has no dependencies.
  final repository = LocalStorageRepository(); // Assuming it can be created like this
  return CategoryNotifier(repository);
});