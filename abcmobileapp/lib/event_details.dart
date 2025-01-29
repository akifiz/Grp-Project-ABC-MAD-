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
  List<Expense> _expenses = [];
  late int _userIndex;

  int numberOfUsers = 1; // Default number of users
  double amount = 0.0;
  bool isEvenSplit = true;
  final List<TextEditingController> costControllers = [];
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    numberOfUsers = widget.event.userId.length;
    _userIndex = widget.event.userId.indexOf(widget.userData.userId);
    _generateControllers();
  }

  void _generateControllers() {
    costControllers.clear();
    for (int i = 0; i < numberOfUsers; i++) {
      costControllers.add(TextEditingController());
    }
    _updateCostSplit();
  }

  void _updateCostSplit() {
    if (isEvenSplit && numberOfUsers > 0) {
      double splitAmount = amount / numberOfUsers;
      for (var controller in costControllers) {
        controller.text = splitAmount.toStringAsFixed(2);
      }
    }
  }

  Future<void> _loadExpenses() async {
    try {
      final handler = FirebaseHandler();
      List<Expense> eventExpenses =
          await handler.fetchExpenses(widget.event.eventId);
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

  Future<void> _updateBalance(Expense newExpense) async {
    try {
      List<String> newBalance =
          calculateBalance(widget.event.balance, newExpense);
      setState(() {
        widget.event.balance = newBalance;
        widget.event.totalSpending += newExpense.amount;
      });
      final handler = FirebaseHandler();
      handler.updateBalance(
          newBalance, widget.event.eventId, widget.event.totalSpending);
    } catch (e) {
      print('Error updating balance: $e');
    }
  }

  List<String> calculateBalance(
      List<String> originalBalance, Expense newExpense) {
    List<List<double>> balance = mapToDoubleListList(originalBalance);
    List<double> costSplit = mapToDoubleList(newExpense.split);
    int payerIndex = newExpense.paidBy;

    for (var i = 0; i < balance.length; i++) {
      if (i == payerIndex) {
        balance[i] = addDoubleLists(balance[i], costSplit);
        continue;
      }
      for (var j = 0; j < balance[i].length; j++) {
        if (j == payerIndex) {
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
        Text(
          "Total Spent: ${widget.event.totalSpending}\nYour spending: ${mapToDoubleList(widget.event.balance[_userIndex])[_userIndex]}\nBalance: ${widget.event.balance[_userIndex]}",
          style: TextStyle(
              color: Colors.black,
              backgroundColor: const Color.fromARGB(255, 240, 215, 245)),
        ),
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
                              String? splitErrorMessage;
                              String? titleErrorMessage;
                              return StatefulBuilder(builder: (context,setState){   
                                  bool _validateSplit() {
                                  double totalCost = costControllers.fold( 0.0,(sum, controller) => sum +(double.tryParse(controller.text) ?? 0.0));
                                  if (totalCost != amount) {
                                    setState(() {
                                      splitErrorMessage = 'Total cost split must add up to the amount';
                                    });
                                    return false;
                                  }
                                  setState(() {
                                    splitErrorMessage = null;
                                  });
                                  return true;
                                }

                                bool _validateTitle(){
                                  if(titleController.text == ''){
                                    setState(() {
                                      titleErrorMessage = 'Expense title cannot be empty';
                                    });
                                    return false;
                                  }
                                  setState(() {
                                    titleErrorMessage = null;
                                  });
                                  return true;
                                }
                                return AlertDialog(
                                  title: const Text('Add Expense'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                              labelText: 'Title'),
                                          controller: titleController,
                                        ),
                                        const SizedBox(height: 8),
                                        if (titleErrorMessage != null)
                                          Text(
                                            titleErrorMessage!,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              labelText: 'Amount'),
                                          controller: amountController,
                                          onChanged: (value) {
                                            double? parsedValue = double.tryParse(value);
                                            if (parsedValue != null && parsedValue >= 0) {
                                              setState(() {
                                                amount = parsedValue;
                                                _updateCostSplit();
                                              });
                                            } else {
                                              amountController.text = ''; // Reset to zero if input is negative
                                              amountController.selection = TextSelection.fromPosition(
                                                TextPosition(offset: amountController.text.length),
                                              );
                                            } 
                                          }
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Cost Split:'),
                                            ToggleButtons(
                                              isSelected: [
                                                isEvenSplit,
                                                !isEvenSplit
                                              ],
                                              onPressed: (index) {
                                                setState(() {
                                                  isEvenSplit = index == 0;
                                                  print(
                                                      "isEventSplit=$isEvenSplit");
                                                  _updateCostSplit();
                                                });
                                              },
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  child: Text('Even'),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                                  child: Text('Custom'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        if (splitErrorMessage != null)
                                          Text(
                                            splitErrorMessage!,
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            itemCount: numberOfUsers,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(widget
                                                          .event.userId[index]),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: TextField(
                                                        controller:costControllers[index],
                                                        keyboardType: TextInputType.number,
                                                        decoration: const InputDecoration(labelText:'Cost'),
                                                        enabled: !isEvenSplit,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_validateSplit() && _validateTitle()) {
                                          List<double> costValues = costControllers
                                                  .map((controller) =>double.tryParse(controller.text) ?? 0.0)
                                                  .toList();

                                          _addExpense(new Expense(
                                            id: "EXP${_expenses.length + 1}",
                                            title: titleController.text,
                                            amount: double.tryParse(
                                                    amountController.text) ??
                                                0.0,
                                            paidBy: _userIndex,
                                            split:
                                                doubleListToString(costValues),
                                            date: DateFormat('d MMMM yyyy')
                                                .format(DateTime.now()),
                                            time: DateFormat('h:mm a')
                                                .format(DateTime.now()),
                                          ));
                                          Navigator.of(context).pop();
                                        }

                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ],
                                );
                              });
                            
                            });
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
              colors: [
                const Color.fromARGB(255, 215, 55, 82),
                const Color.fromARGB(255, 139, 37, 37)
              ],
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
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "Paid By: $paidBy",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Split: $split",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  Text(
                    "$date at $time",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
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

String doubleListToString(List<double> doubleList) {
  return doubleList.map((d) => d.toString()).join(',');
}

List<double> addDoubleLists(List<double> list1, List<double> list2) {
  int minLength = list1.length < list2.length ? list1.length : list2.length;
  return List.generate(minLength, (i) => list1[i] + list2[i]);
}
