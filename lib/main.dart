import './widgets/new_transaction.dart';
import './models/trainsaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import 'package:flutter/services.dart';
void main() {
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//    ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          fontFamily: 'Quicksand',
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
// Transaction(
//   id : 't1',
//   title: 'New Shoes',
//   amount: 69.99,
//   date: DateTime.now(),
// ),

// Transaction(
//   id : 't2',
//   title: 'Weekly Groceries',
//   amount: 16.53,
//   date: DateTime.now(),
//   ),
  ];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }
bool _showChart = false;
  void _addNewTransaction(String title, double amount,DateTime chosenDate) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNew(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) => Container(child: NewTransaction(_addNewTransaction)),
    );
  }
  void _deleteTransaction(String id)
  {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery=  MediaQuery.of(context);
    final isLandscape =   mediaQuery.orientation == Orientation.landscape;
    final appBar =  AppBar(
    title: Text(
    'Personal Expenses',
    ),
    actions: <Widget>[
    Builder(
    builder: (context) => IconButton(
    icon: Icon(Icons.add, color: Colors.white),
    onPressed: () => _startAddNew(context)))
    ],
    );
    final txListWidget  = Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top)* 0.7,
        child:TransactionList(_userTransactions,
            _deleteTransaction)
    );
    return Scaffold(
  appBar: appBar,
      body: SingleChildScrollView(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
         if(isLandscape) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Show Chart'),

              Switch(value: _showChart, onChanged:(val)
              {
                setState(() {
                  _showChart = val;
                });
              }
              ),
            ],
          ),
          if(!isLandscape) Container (height:
          (mediaQuery.size.height
              - appBar.preferredSize.height -
              mediaQuery.padding.top)* 0.3,
            child: Chart(_recentTransactions),
          ),
          if(!isLandscape) txListWidget,
          if(isLandscape)
          _showChart ?
          Container (height:
          (mediaQuery.size.height
              - appBar.preferredSize.height -
              mediaQuery.padding.top)* 0.7,
          child: Chart(_recentTransactions),
          ):txListWidget

        ],
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => _startAddNew(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
