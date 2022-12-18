import 'dart:math';
import 'package:expenses/components/chart.dart';
import 'package:flutter/services.dart';

import './components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /***
     * Mantém modo retrato, independente da orientação do dispostivo
     */
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.normal),
          textTheme: ThemeData.light().textTheme.copyWith(
                titleMedium: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                // button: TextStyle(fontWeight: FontWeight.bold),
              ),
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w500))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Novo Tênis de Corrida',
        value: 10190.76,
        date: DateTime.now().subtract(Duration(days: 0))),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Novo Tênis casual',
        value: 810.71,
        date: DateTime.now().subtract(Duration(days: 1))),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Novo Tênis casual',
        value: 3310.71,
        date: DateTime.now().subtract(Duration(days: 4))),
    Transaction(
        id: Random().nextDouble().toString(),
        title: 'Novo Tênis casual',
        value: 10.71,
        date: DateTime.now().subtract(Duration(days: 5))),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date);

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add))
      ],
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Exibir Gráfico'),
                  Switch(
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      })
                ],
              ),
              if (_showChart)
                Container(
                  child: const Card(
                    color: Colors.blue,
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Gráfico'),
                    ),
                  ),
                ),
              if (!_showChart)
                Container(
                  height: availableHeight * 0.30,
                  child: Chart(_recentTransactions),
                ),
              Container(
                height: availableHeight * 0.75,
                child: TransactionList(_transactions, _deleteTransaction),
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
