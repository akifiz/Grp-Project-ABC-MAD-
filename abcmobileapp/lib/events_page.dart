import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'event_details.dart';
import 'app_colors.dart';
import 'model.dart';
import 'tilebutton.dart';
import 'package:intl/intl.dart';
class EventsPage extends StatefulWidget {
  final User userData;
  final List<Event> events;

  const EventsPage({
    Key? key,
    required this.userData,
    required this.events,
  }) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _formKey = GlobalKey<FormState>();
  final _peopleController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _peopleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ✅ Function to Delete Event with Firebase
  void _deleteEvent(Event event) async {
    final handler = FirebaseHandler();

    try {
      await handler.deleteEvent(event); // ✅ Delete event from Firebase

      setState(() {
        widget.events.removeWhere((e) => e.eventId == event.eventId); // ✅ Remove from UI
      });

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event deleted successfully!'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // ❌ Handle deletion failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting event: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ Confirmation Dialog Before Deleting
  void _confirmDelete(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text('Delete Event', style: TextStyle(color: AppColors.text)),
          content: Text(
            'Are you sure you want to delete "${event.title}"?',
            style: TextStyle(color: AppColors.main),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.text)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deleteEvent(event); // ✅ Delete event
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ✅ Function to Add Event
  void _addEvent(Event event) {
    final handler = FirebaseHandler();

    setState(() {
      handler.createEvent(event); // ✅ Save to Firebase
      widget.events.add(event); // ✅ Update UI
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event created successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ✅ Function to Show Create Event Dialog
  void _showCreateEventDialog() {
    DateTime selectedDate = DateTime.now();

    _nameController.clear();
    _peopleController.text = '2';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Create New Event',
            style: TextStyle(color: AppColors.text),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: AppColors.main),
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      labelStyle: TextStyle(color: AppColors.text),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.text),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.text),
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an event name';
                      }
                      if (value.length > 50) {
                        return 'Event name too long (max 50 characters)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _peopleController,
                    style: TextStyle(color: AppColors.main),
                    decoration: InputDecoration(
                      labelText: 'Number of People',
                      labelStyle: TextStyle(color: AppColors.text),
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.text),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        selectedDate.toString().split(' ')[0],
                        style: TextStyle(color: AppColors.main),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.text)),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addEvent(
                    Event(
                      eventId: "E${widget.events.length + 1}",
                      title: _nameController.text,
                      totalSpending: 0,
                      userId: ['U1', 'U2'],
                      date: DateFormat('d MMMM yyyy').format(DateTime.now()),
                      time: DateFormat('h:mm a').format(DateTime.now()),
                      balance: ['0,0,', '0,0,'],
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Create', style: TextStyle(color: AppColors.text)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'EVENTS',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors.pagen,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: widget.events.length,
                itemBuilder: (context, index) {
                  final event = widget.events[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TileButton(
                      text: "${event.title}\n${event.date}\n${event.userId.length} People",
                      icon: Icons.event,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsPage(
                              userData: widget.userData,
                              event: widget.events[index],
                            ),
                          ),
                        );
                      },
                      onDelete: () => _confirmDelete(event),
                    ),
                  );
                },
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  backgroundColor: AppColors.text,
                  onPressed: _showCreateEventDialog,
                  child: Icon(Icons.add, color: AppColors.main),
                  tooltip: 'Create New Event',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
