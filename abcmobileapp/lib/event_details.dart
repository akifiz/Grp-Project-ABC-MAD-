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
  final List<String> _messages = []; // List to store chat messages

  void _sendMessage() {
    setState(() {
      _messages.add(_expenseTitleController.text);
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
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ExpenseBubble(
                message: _messages[_messages.length - 1 - index],
                isSentByMe: true, // don't alternate sender
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
                              title: Text('Record an expense', style: TextStyle(color: AppColors.main)),
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
  final String message;
  final bool isSentByMe;

  const ExpenseBubble({
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.symmetric(
            vertical: height * 0.06, horizontal: width * 0.4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.text, Colors.lightBlue],
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
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
