import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/screens/category_management_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart' as a;
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = a.Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Administrar Categorías'),
            subtitle: const Text(
              'Crea, edita y elimina tus categorías de gastos.',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryManagementScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Eliminar todos los datos'),
            subtitle: const Text(
              'Esto borrará permanentemente todas tus transacciones.',
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Estás seguro?'),
                  content: const Text('Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(localStorageRepositoryProvider).wipeData();
                ref.read(transactionProvider.notifier).loadTransactions();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todos los datos han sido eliminados.'),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Exportar Backup local'),
            subtitle: const Text(
              'Guarda un archivo JSON con tus transacciones.',
            ),
            onTap: () async {
              final transactions = ref.read(transactionProvider);
              if (transactions.isEmpty) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No hay transacciones para exportar.'),
                  ),
                );
                return;
              }

              final transactionsJson = jsonEncode(
                transactions.map((t) => t.toJson()).toList(),
              );
              final directory = await getApplicationDocumentsDirectory();
              final path = '${directory.path}/myapp_backup.json';
              final file = File(path);
              await file.writeAsString(transactionsJson);

              if (!mounted) return; // Safety check
              await Share.shareXFiles([XFile(path)], text: 'Myapp Backup');
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Importar Backup'),
            subtitle: const Text(
              'Restaura tus transacciones desde un archivo JSON.',
            ),
            onTap: () async {
              try {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );

                if (result != null) {
                  File file = File(result.files.single.path!);
                  String content = await file.readAsString();
                  List<dynamic> jsonList = jsonDecode(content);
                  List<Transaction> transactions = jsonList
                      .map((json) => Transaction.fromJson(json))
                      .toList();

                  final repository = ref.read(localStorageRepositoryProvider);
                  await repository
                      .wipeData(); // Clear existing data from import
                  for (var transaction in transactions) {
                    await repository.saveTransaction(transaction);
                  }

                  ref.read(transactionProvider.notifier).loadTransactions();

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Backup importado con éxito!'),
                    ),
                  );
                }
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al importar el backup: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
} //as
