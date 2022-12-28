// ignore_for_file: prefer_const_constructors

import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();

  final valueController = TextEditingController();

  DateTime _selectDate = DateTime.now();

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectDate);
  }

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            // ignore: prefer_if_null_operators
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: <Widget>[
              AdaptativeTextField(
                  onSubmittedForm: (_) => _submitForm,
                  keyboardType: TextInputType.text,
                  textController: titleController,
                  label: 'Título'),

              AdaptativeTextField(
                  onSubmittedForm: (_) => _submitForm(),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textController: valueController,
                  label: 'Valor (R\$)'),
              // TextField(
              //     controller: valueController,
              //     keyboardType:
              //         const TextInputType.numberWithOptions(decimal: true),
              //     onSubmitted: (_) => _submitForm,
              //     decoration: const InputDecoration(labelText: 'Valor (R\$)')),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectDate == null
                          ? 'Nenhuma data selecionada!'
                          : 'Data Formatada: ${DateFormat('dd/M/y').format(_selectDate)}',
                    ),
                    TextButton(
                      onPressed: _showDatePicker,
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor),
                      child: Text(
                        'Selecionar Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AdaptativeButton(
                      label: 'Nova Transação', onPressed: _submitForm)
                  // ElevatedButton(
                  //   onPressed: _submitForm,
                  //   style: const ButtonStyle(
                  //       backgroundColor:
                  //           MaterialStatePropertyAll(Colors.purple)),
                  //   child: const Text(
                  //     'Nova Transação',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
