// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'dart:io';

import 'package:expenses/components/chart.dart';
import 'package:flutter/cupertino.dart';

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
          primaryColor: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.normal),
          textTheme: ThemeData.light().textTheme.copyWith(
                titleMedium: TextStyle(
                    color: Colors.white10,
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: Random().nextDouble().toString(),
    //     title: 'Novo Tênis de Corrida',
    //     value: 10190.76,
    //     date: DateTime.now().subtract(Duration(days: 0))),
    // Transaction(
    //     id: Random().nextDouble().toString(),
    //     title: 'Novo Tênis casual',
    //     value: 810.71,
    //     date: DateTime.now().subtract(Duration(days: 1))),
    // Transaction(
    //     id: Random().nextDouble().toString(),
    //     title: 'Novo Tênis casual',
    //     value: 3310.71,
    //     date: DateTime.now().subtract(Duration(days: 4))),
    // Transaction(
    //     id: Random().nextDouble().toString(),
    //     title: 'Novo Tênis casual',
    //     value: 10.71,
    //     date: DateTime.now().subtract(Duration(days: 5))),
  ];

  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

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

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
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
    final isLandscapeOrientation =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.list_dash : Icons.list;
    final iconChart =
        Platform.isIOS ? CupertinoIcons.chart_bar : Icons.show_chart;

    final actions = <Widget>[
      if (isLandscapeOrientation)
        _getIconButton(
          _showChart ? iconList : iconChart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = AppBar(
        title: Text(
          'Despesas Pessoais',
        ),
        actions: actions);

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SafeArea(
        child: SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscapeOrientation)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Exibir Gráfico',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 14,
                    ),
                  ),
                  Switch.adaptive(
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      })
                ],
              ),
            if (_showChart || !isLandscapeOrientation)
              Container(
                height: availableHeight * (isLandscapeOrientation ? 0.8 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscapeOrientation)
              Container(
                height: availableHeight * (isLandscapeOrientation ? 1 : 0.7),
                child: TransactionList(_transactions, _deleteTransaction),
              ),
          ]),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
