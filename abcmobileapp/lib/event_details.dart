import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatefulWidget {
  final User userData;
  final Event event;

  const EventDetailsPage({
    Key? key,
    required this.userData,
    required this.event,
  }) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _expenseTitleController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  List<Expense> _expenses = [];
  late int _userIndex;

  @override
  void initState (){
    super.initState();
    _loadExpenses();
    _userIndex = widget.event.userId.indexOf(widget.userData.userId);
  }
  
  Future<void> _loadExpenses() async{
    try {
      final handler = FirebaseHandler();
      List<Expense> eventExpenses = await handler.fetchExpenses(widget.event.eventId);
      setState(() {
        _expenses = eventExpenses;
      });
    } catch (e) {
      print('Error loading events: $e');
    }
  }


  void _addExpense(Expense expense) {
    try {
      final handler = FirebaseHandler();
      handler.createExpense(expense, widget.event.eventId);
      setState(() {
        _expenses.add(expense);
        _updateBalance(expense);
      });
    } catch (e) {
      print('Error adding an expense: $e');
    }
  }

  Future<void> _updateBalance (Expense newExpense) async {
    try {
      List<String> newBalance = calculateBalance(widget.event.balance, newExpense);
      setState(() {
        widget.event.balance = newBalance;
        widget.event.totalSpending += newExpense.amount;
      });
      final handler = FirebaseHandler();
      handler.updateBalance(newBalance, widget.event.eventId, widget.event.totalSpending);
    } catch (e) {
      print('Error updating balance: $e');
    }
  }

  List<String> calculateBalance(List<String> originalBalance, Expense newExpense){
    List<List<double>> balance = mapToDoubleListList(originalBalance);
    List<double> costSplit = mapToDoubleList(newExpense.split);
    int payerIndex = newExpense.paidBy;

    for(var i = 0; i < balance.length; i++){
      if (i == payerIndex) {
        balance[i] = addDoubleLists(balance[i], costSplit);
        continue;
      }
      for(var j = 0; j < balance[i].length; j++){
        if(j == payerIndex){
          balance[i][j] -= costSplit[i];
          continue;
        }
      }
    }
    return doubleListListToStringList(balance);
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.event.title),
        backgroundColor: AppColors.text,
        foregroundColor: Colors.white,
      ),
      body: Column(children: [
        Text("Total Spent: ${widget.event.totalSpending}\nYour spending: ${mapToDoubleList(widget.event.balance[_userIndex])[_userIndex]}\nBalance: ${widget.event.balance[_userIndex]}"),
        Divider(height: 1),
        Expanded(
          child: ListView.builder(
            reverse: true, // Messages start from the bottom
            itemCount: _expenses.length,
            itemBuilder: (context, index) {
              return ExpenseBubble(
                title: _expenses[_expenses.length - 1 - index].title,
                amount: _expenses[_expenses.length - 1 - index].amount,
                paidBy: _expenses[_expenses.length - 1 - index].paidBy,
                split: _expenses[_expenses.length - 1 - index].split,
                date: _expenses[_expenses.length - 1 - index].date,
                time: _expenses[_expenses.length - 1 - index].time,
              );
            },
          ),
        ),
        Divider(height: 1),
        Container(
            color: AppColors.text,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  ElevatedButton(
                      onPressed: () {}, child: Text("Calculate Balance")),
                  SizedBox(width: 10),
                  ElevatedButton(
                      child: Text("Add an expense"),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: AppColors.background,
                              title: Text('Record an expense',
                                  style: TextStyle(color: AppColors.main)),
                              content: Column(children: [
                                TextFormField(
                                  controller: _expenseTitleController,
                                  style: TextStyle(color: AppColors.main),
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    labelStyle:
                                        TextStyle(color: AppColors.text),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.text),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.text),
                                    ),
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter expense amount';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _expenseAmountController,
                                  style: TextStyle(color: AppColors.main),
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    labelStyle:
                                        TextStyle(color: AppColors.text),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.text),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.text),
                                    ),
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter expense title';
                                    }
                                    if (value.length > 50) {
                                      return 'Expense title too long (max 50 characters)';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  maxLength: 50,
                                ),
                              ]),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _addExpense(
                                      new Expense(
                                        id: "EXP${_expenses.length + 1}",
                                        title: "Expense EXP${_expenses.length + 1}",
                                        amount: 100,
                                        paidBy: 0,
                                        split: "50,50",
                                        date: DateFormat('d MMMM yyyy').format(DateTime.now()),
                                        time: DateFormat('h:mm a').format(DateTime.now()), 
                                      )
                                    );
                                  },
                                  child: Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ])))
      ]),
    );
  }
}

class ExpenseBubble extends StatelessWidget {
  final String title;
  final double amount;
  final int paidBy;
  final String split;
  final String date;
  final String time;

  const ExpenseBubble({
    Key? key,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.split,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 215, 55, 82), const Color.fromARGB(255, 139, 37, 37)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(4, 4), // Shadow direction
                blurRadius: 10, // Softness of the shadow
                spreadRadius: 1, // How far the shadow spreads
              ),
            ],
          ),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount: \$${amount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  Text(
                    "Paid By: $paidBy",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Split: $split",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                  Text(
                    "$date at $time",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}


//helper methods
List<double> mapToDoubleList(String str) {
  return str
      .split(',') // Split by comma
      .where((s) => s.isNotEmpty) // Remove empty values
      .map((s) => double.parse(s)) // Convert to double
      .toList();
}

List<List<double>> mapToDoubleListList(List<String> stringList) {
  return stringList.map((str) {
    return mapToDoubleList(str);
  }).toList();
}

List<String> doubleListListToStringList(List<List<double>> doubleList) {
  return doubleList.map((innerList) {
    return innerList.map((d) => d.toString()).join(',');
  }).toList();
}

List<double> addDoubleLists(List<double> list1, List<double> list2) {
  int minLength = list1.length < list2.length ? list1.length : list2.length;
  return List.generate(minLength, (i) => list1[i] + list2[i]);
}
