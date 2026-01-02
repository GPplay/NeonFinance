
import 'package:hive/hive.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/models/transaction.dart';

class LocalStorageRepository {
  static const String _transactionsBoxName = 'transactions';
  static const String _categoriesBoxName = 'categories';

  Future<void> init() async {
    await Hive.openBox<Transaction>(_transactionsBoxName);
    await Hive.openBox<Category>(_categoriesBoxName);

    // Add default categories if the box is empty
    final categoryBox = Hive.box<Category>(_categoriesBoxName);
    if (categoryBox.isEmpty) {
      for (var category in defaultCategories) {
        await categoryBox.put(category.name, category);
      }
    }
  }

  Future<void> saveTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>(_transactionsBoxName);
    await box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    final box = Hive.box<Transaction>(_transactionsBoxName);
    await box.delete(id);
  }

  List<Transaction> getTransactions(DateTime start, DateTime end) {
    final box = Hive.box<Transaction>(_transactionsBoxName);
    return box.values
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }

  List<Category> getCategories() {
    final box = Hive.box<Category>(_categoriesBoxName);
    return box.values.toList();
  }

  Future<void> saveCategory(Category category) async {
    final box = Hive.box<Category>(_categoriesBoxName);
    await box.put(category.name, category);
  }

  Future<void> deleteCategory(String name) async {
    final box = Hive.box<Category>(_categoriesBoxName);
    await box.delete(name);
  }

  Future<void> updateCategory(String oldName, Category newCategory) async {
    final box = Hive.box<Category>(_categoriesBoxName);
    await box.delete(oldName);
    await box.put(newCategory.name, newCategory);
  }

  Future<void> wipeData() async {
    final transactionBox = Hive.box<Transaction>(_transactionsBoxName);
    await transactionBox.clear();
    final categoryBox = Hive.box<Category>(_categoriesBoxName);
    await categoryBox.clear();
  }
}
