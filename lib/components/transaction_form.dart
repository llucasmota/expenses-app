// ignore_for_file: prefer_const_constructors

import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_date_picker.dart';
import 'package:expenses/components/adaptative_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  const TransactionForm(this.onSubmit, {super.key});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime _selectDate = DateTime.now();

  _TransactionFormState() {
    print('Constructor _TransactionFormState');
  }
  @override
  void initState() {
    super.initState();
    print('initState() _TransactionFormState');
  }

  @override
  void didUpdateWidget(TransactionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget() _TransactionFormState');
  }

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectDate);
  }

  _onDateChanged(DateTime dateTime) {
    setState(() {
      _selectDate = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() TransactionForm');
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
                label: 'Valor (R\$)',
              ),
              AdaptativeDatePicker(
                onDateChanged: _onDateChanged,
                selectDate: _selectDate,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AdaptativeButton(
                      label: 'Nova Transação', onPressed: _submitForm)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
