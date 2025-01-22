import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  final Function(Event) onEventUpdated;

  const EventDetailsPage({
    Key? key,
    required this.event,
    required this.onEventUpdated,
  }) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _messageController = TextEditingController();
  final _expenseTitleController = TextEditingController();
  final _expAmountController = TextEditingController();
  final List<String> _expenseTitle = []; // List to store chat messages

  void _sendMessage() {
    setState(() {
      _expenseTitle.add(_expenseTitleController.text);
    });
    _messageController.clear(); // Clear the input field
    _expenseTitleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.event.name),
        backgroundColor: AppColors.text,
        foregroundColor: Colors.white,
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            reverse: true, // Messages start from the bottom
            itemCount: _expenseTitle.length,
            itemBuilder: (context, index) {
              return ExpenseBubble(
                title: _expenseTitle[_expenseTitle.length - 1 - index],
                amount: 100.50,
                paidBy: "User1",
                split: "Equally (4 people)",
                date: "17 Jan 2025",
                time: "10:20 p.m.",
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
                                  controller: _expAmountController,
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
                                    _sendMessage();
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
  final String paidBy;
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
