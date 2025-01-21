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
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = []; // List to store chat messages

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
      });
      _messageController.clear(); // Clear the input field
    }
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Messages start from the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: _messages[_messages.length - 1 - index],
                  isSentByMe: true, // don't alternate sender
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Center(
        child: ElevatedButton(
          child: 
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Dialog Title'),
                  content: Text('This is the content of the dialog.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          ),
            )
          )
        ]
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const ChatBubble({
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentByMe ? AppColors.sub : const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isSentByMe ? Radius.circular(12) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : Radius.circular(12),
          ),
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