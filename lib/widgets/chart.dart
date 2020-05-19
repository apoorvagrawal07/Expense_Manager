import 'package:flutter/material.dart';
import '../models/trainsaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  double get totalSpending{

    return groupedTransactionValues.fold(0.0, (previousValue, element) => previousValue+element['amount']);
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (int i = 0; i < recentTransactions.length; i++) {
        if (weekDay.day == recentTransactions[i].date.day &&
            weekDay.month == recentTransactions[i].date.month &&
            weekDay.year == recentTransactions[i].date.year)
          totalSum += recentTransactions[i].amount;
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Container(

        child:Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children:
            groupedTransactionValues.map((e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(label: e['day'],
                spendingAmount: e['amount'],
                spendingPctTotal: totalSpending ==0?0.0:(e['amount'] as double)/totalSpending),
              );
            }).toList(),
        ),
      ),
    ));
  }
}
