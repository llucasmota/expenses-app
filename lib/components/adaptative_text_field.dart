import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

//  controller: valueController,
//keyboardType:const TextInputType.numberWithOptions(decimal: true),
//onSubmitted: (_) => _submitForm(),
//decoration: const InputDecoration(labelText: 'Valor (R\$)'))

class AdaptativeTextField extends StatelessWidget {
  final void Function(String value) onSubmittedForm;
  final TextInputType keyboardType;
  final TextEditingController textController;
  // final InputDecoration? inputDecorationAndroid;
  // final BoxDecoration? inputDecorationIOS;
  final String label;

  AdaptativeTextField({
    required this.onSubmittedForm,
    this.keyboardType = TextInputType.text,
    required this.textController,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: CupertinoTextField(
              controller: textController,
              onSubmitted: onSubmittedForm,
              keyboardType: keyboardType,
              placeholder: label,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            ),
          )
        : TextField(
            style: TextStyle(color: Colors.black),
            controller: textController,
            keyboardType: keyboardType,
            onSubmitted: onSubmittedForm,
            decoration: InputDecoration(
              labelText: label,
            ));
  }
}
