import 'dart:math';

import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser({super.key});

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transactions = [
    Transaction(
        id: 'one',
        title: 'Novo Tênis de COrrida',
        value: 310.76,
        date: DateTime.now()),
    Transaction(
        id: 'two',
        title: 'Novo Tênis casual',
        value: 310.71,
        date: DateTime.now()),
    // Transaction(
    //     id: 'two',
    //     title: 'Novo Tênis casual',
    //     value: 310.71,
    //     date: DateTime.now()),
    // Transaction(
    //     id: 'two',
    //     title: 'Novo Tênis casual',
    //     value: 310.71,
    //     date: DateTime.now()),
    // Transaction(
    //     id: 'two',
    //     title: 'Novo Tênis casual',
    //     value: 310.71,
    //     date: DateTime.now())
  ];

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: DateTime.now());

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TransactionList(_transactions),
        TransactionForm(_addTransaction)
      ],
    );
  }
}
