
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late bool isExpense;

  @HiveField(3)
  late String categoryName;

  @HiveField(4)
  late int categoryColor;

  @HiveField(5)
  late int categoryIcon;

  @HiveField(6)
  late DateTime date;

  @HiveField(7)
  late String? note;

  Transaction({
    required this.amount,
    required this.isExpense,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.date,
    this.note,
  }) {
    id = const Uuid().v4();
  }

  // Private constructor for fromJson to use
  Transaction._({
    required this.id,
    required this.amount,
    required this.isExpense,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'isExpense': isExpense,
        'categoryName': categoryName,
        'categoryColor': categoryColor,
        'categoryIcon': categoryIcon,
        'date': date.toIso8601String(),
        'note': note,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction._(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(), // Ensure amount is a double
      isExpense: json['isExpense'],
      categoryName: json['categoryName'],
      categoryColor: json['categoryColor'],
      categoryIcon: json['categoryIcon'],
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }
}
