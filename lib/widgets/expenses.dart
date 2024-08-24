import 'package:e_tracker/widgets/chart/chart.dart';
import 'package:e_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:e_tracker/models/expense.dart';
import 'package:e_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredexpenses = [
    Expense(
      title: "Flutter Course",
      amount: 74.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Fees",
      amount: 3000.00,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Europe",
      amount: 5000.00,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: "Cinema",
      amount: 100.00,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: "Shopping",
      amount: 400.00,
      date: DateTime.now(),
      category: Category.shopping,
    ),
    Expense(
      title: "Grocery",
      amount: 300.00,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredexpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredexpenses.indexOf(expense);
    setState(() {
      _registeredexpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredexpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text("No expenses found! Start adding some."),
    );
    if (_registeredexpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredexpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
        appBar: AppBar(
          
          title: const Text("Flutter Expense Tracker"),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredexpenses),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expenses: _registeredexpenses),
                  ),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ));
  }
}
