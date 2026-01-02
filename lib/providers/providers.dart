import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// Added this line back
import 'package:myapp/models/category.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/repositories/local_storage_repository.dart';

// --- Repository Provider ---
final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return LocalStorageRepository();
});

// --- Transaction Notifier and Provider ---
class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final LocalStorageRepository _repository;

  TransactionNotifier(this._repository) : super([]) {
    loadTransactions();
  }

  void loadTransactions() {
    final now = DateTime.now();
    final oneMonthAgo = now.subtract(const Duration(days: 30));
    state = _repository.getTransactions(oneMonthAgo, now);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.saveTransaction(transaction);
    loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    loadTransactions();
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  final repository = ref.watch(localStorageRepositoryProvider);
  return TransactionNotifier(repository);
});

// --- Category Notifier and Provider ---
class CategoryNotifier extends StateNotifier<List<Category>> {
  final LocalStorageRepository _repository;

  CategoryNotifier(this._repository) : super(_repository.getCategories());

  void addCategory(Category category) {
    _repository.saveCategory(category);
    state = _repository.getCategories();
  }

  void updateCategory(String oldName, Category newCategory) {
    _repository.updateCategory(oldName, newCategory);
    state = _repository.getCategories();
  }

  void deleteCategory(String name) {
    _repository.deleteCategory(name);
    state = _repository.getCategories();
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  final repository = ref.watch(localStorageRepositoryProvider);
  return CategoryNotifier(repository);
});
