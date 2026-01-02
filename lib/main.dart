
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:myapp/models/category.dart';
import 'package:myapp/models/category_adapter.dart';
import 'package:myapp/models/transaction.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/screens/add_transaction_screen.dart';
import 'package:myapp/screens/settings_screen.dart';
import 'package:myapp/screens/stats_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart' as a;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());

  // Create a ProviderContainer that will be used by the app.
  final container = ProviderContainer();
  // Initialize the repository using the container.
  await container.read(localStorageRepositoryProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: a.ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = a.Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'NeonFinance',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: const ColorScheme.light(
          primary: Colors.blueAccent,
          secondary: Colors.pinkAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F5),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.purpleAccent,
          secondary: Colors.tealAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    // Calculate total balance
    final totalBalance = transactions.fold<double>(0.0, (sum, item) {
      return item.isExpense ? sum - item.amount : sum + item.amount;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('NeonFinance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Balance Total',
                  style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${totalBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          // List of transactions
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: Icon(
                    IconData(transaction.categoryIcon, fontFamily: 'MaterialIcons'),
                    color: Color(transaction.categoryColor),
                  ),
                  title: Text(transaction.categoryName, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                  subtitle: Text(transaction.date.toString(), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                  trailing: Text(
                    '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.isExpense ? Colors.redAccent : Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
