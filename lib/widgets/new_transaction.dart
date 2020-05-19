import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NewTransaction extends StatefulWidget {
 final Function  newTxn;
 NewTransaction(this.newTxn);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
 final _titleController = TextEditingController();
 final _amountController = TextEditingController();
  DateTime _selectedDate;

void _submitData(){
  if(_amountController.text.isEmpty)
    return;
final enteredTitle  = _titleController.text;
final enteredAmount = double.parse(_amountController.text);
if(enteredTitle.isEmpty || enteredAmount <=0 || _selectedDate == null){
  return;
}
 widget.newTxn(enteredTitle,enteredAmount,_selectedDate);

Navigator.of(context).pop();

}
void _datePicker(BuildContext context){
  showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now()).then((pickedDate) {
        if(pickedDate == null)
            return;
        setState(() {
          _selectedDate = pickedDate;
        });
  });
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(top: 10,left: 10,
                    right: 10, bottom: MediaQuery.of(context).viewInsets.bottom+10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                      onSubmitted: (_) => _submitData(),
                      ),
                      TextField(
                      //   onChanged: (val)=> amountInput = val,
                         decoration: InputDecoration(labelText: 'Amount'),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _submitData(),
                      ),
                      Container(
                        height: 70,
                        child: Row(
                        children: <Widget>[
                          Expanded(child: Text(_selectedDate == null
                              ? 'No Date Chosen!':
                          'Chosen Date: ${DateFormat.yMMMd().format(_selectedDate)}')),
                          FlatButton(onPressed: () {_datePicker(context);
                          },
                              child: Text('Choose Date',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],

                      ),
                      ),
                      RaisedButton(
                        onPressed: _submitData,
                       color: Colors.purple,
                       child: Text('Add Transaction'),
                        textColor: Colors.white,
                       ),
                    ],
                ),
              ),
          ));
     }
}