
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/providers/providers.dart';
import 'package:intl/intl.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    // Filter for expenses only
    final expenses = transactions.where((t) => t.isExpense).toList();

    // --- PIE CHART LOGIC ---
    final Map<String, double> categoryExpenses = {};
    double totalExpenses = 0;
    for (var expense in expenses) {
      categoryExpenses.update(expense.categoryName, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
      totalExpenses += expense.amount;
    }

    final pieChartSections = categoryExpenses.entries.map((entry) {
      final percentage = totalExpenses > 0 ? (entry.value / totalExpenses * 100) : 0;
      return PieChartSectionData(
        color: Color(expenses.firstWhere((e) => e.categoryName == entry.key).categoryColor),
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 100,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    // --- BAR CHART LOGIC ---
    final Map<String, double> dailyExpenses = {};
    final List<String> dayOrder = List.generate(7, (i) {
      return DateFormat('E').format(DateTime.now().subtract(Duration(days: 6 - i)));
    });

    for (var day in dayOrder) {
      dailyExpenses[day] = 0.0;
    }

    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final recentExpenses = expenses.where((e) => e.date.isAfter(sevenDaysAgo));

    for (var expense in recentExpenses) {
      final day = DateFormat('E').format(expense.date);
      if (dailyExpenses.containsKey(day)) {
        dailyExpenses.update(day, (value) => value + expense.amount);
      }
    }

    final barChartGroups = dayOrder.asMap().entries.map((entry) {
      final dayIndex = entry.key;
      final dayName = entry.value;
      final value = dailyExpenses[dayName] ?? 0.0;

      return BarChartGroupData(
        x: dayIndex,
        barRods: [
          BarChartRodData(
            toY: value,
            color: Colors.lightBlueAccent,
            width: 16,
            borderRadius: BorderRadius.zero,
          )
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Gastos por Categoría',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: expenses.isEmpty
                    ? const Center(child: Text('No hay gastos para mostrar.', style: TextStyle(color: Colors.white)))
                    : PieChart(
                        PieChartData(
                          sections: pieChartSections,
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Gastos Diarios (Últimos 7 días)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: expenses.isEmpty
                    ? const Center(child: Text('No hay gastos para mostrar.', style: TextStyle(color: Colors.white)))
                    : BarChart(
                        BarChartData(
                          barGroups: barChartGroups,
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);
                                  Widget text;
                                  if (value.toInt() >= 0 && value.toInt() < dayOrder.length) {
                                    // Use the first letter of the day name
                                    text = Text(dayOrder[value.toInt()].substring(0, 1), style: style);
                                  } else {
                                    text = const Text('', style: style);
                                  }
                                  return text; // <-- THE FIX IS HERE!
                                },
                                reservedSize: 28,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(enabled: false),
                          gridData: const FlGridData(show: false),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
