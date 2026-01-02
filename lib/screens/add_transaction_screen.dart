
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isExpense = true;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = defaultCategories.first;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione una categoría.')),
        );
        return;
      }

      final transaction = Transaction(
        amount: double.parse(_amountController.text),
        isExpense: _isExpense,
        categoryName: _selectedCategory!.name,
        categoryColor: _selectedCategory!.color.toARGB32(),
        categoryIcon: _selectedCategory!.icon.codePoint,
        date: _selectedDate,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );
      ref.read(transactionProvider.notifier).addTransaction(transaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = defaultCategories;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Transacción'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Note Field
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Nota (Opcional)',
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 20),

              // Date Picker
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Fecha: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),

              // Expense/Income Switch
              SwitchListTile(
                title: Text(_isExpense ? 'Gasto' : 'Ingreso'),
                value: _isExpense,
                onChanged: (value) {
                  setState(() {
                    _isExpense = value;
                  });
                },
                secondary: Icon(_isExpense ? Icons.arrow_downward : Icons.arrow_upward),
              ),
              const SizedBox(height: 20),

              // Category Grid
              Text('Categoría', style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: categories.map((category) {
                  final isSelected = _selectedCategory?.name == category.name;
                  return ChoiceChip(
                    label: Text(category.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    avatar: Icon(category.icon, color: isSelected ? Colors.white : category.color),
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt),
                label: const Text('Guardar Transacción'),
                onPressed: _submitTransaction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
