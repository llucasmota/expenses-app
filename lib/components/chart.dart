import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart(this.recentTransaction, {super.key});
/**
 * List.generate recebe o tamanho primeiramente e o indice
 */
  List<Map<String, Object>> get groupedTransactions {
    /**
     * Duration pega o dia de hoje e subtrai o valor do index
     */
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;
        bool sameDMY = sameDay && sameMonth && sameYear;

        if (sameDMY) {
          totalSum += recentTransaction[i].value;
        }
      }

/**
 * DateFormat.E().format(weekDay)[0]
 * pega a primeirta letra do dia
 */
      return {'day': DateFormat.E().format(weekDay)[0], 'value': totalSum};
      //reversed utilizado para que os dias mais atuais fiquem no início
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(
        0.0, (sum, tr) => sum + (tr['value'] as double));
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((trGrouped) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: '${trGrouped['day']}',
                  value: double.parse('${trGrouped['value']}'),
                  percentage: _weekTotalValue == 0
                      ? 0
                      : (trGrouped['value'] as double) / _weekTotalValue),
            );
          }).toList(),
        ),
      ),
    );
  }
}
