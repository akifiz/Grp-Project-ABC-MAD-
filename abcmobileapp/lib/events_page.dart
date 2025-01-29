// events_page.dart
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _peopleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showCreateEventDialog() {
    DateTime selectedDate = DateTime.now();
    
    // Reset controllers
    _nameController.clear();
    _peopleController.text = '2';

    showDialog(
      context: context,
      barrierDismissible: false, // Must use buttons to close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Create New Event',
            style: TextStyle(color: AppColors.text),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView( // Make scrollable for small screens
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
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _peopleController,
                    style: TextStyle(color: AppColors.main),
                    decoration: InputDecoration(
                      labelText: 'Number of People',
                      labelStyle: TextStyle(color: AppColors.text),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.text),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.text),
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      hintText: 'Enter number of participants',
                      hintStyle: TextStyle(color: AppColors.main.withOpacity(0.5)),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4), // Reasonable limit
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of people';
                      }
                      final number = int.tryParse(value);
                      if (number == null) {
                        return 'Please enter a valid number';
                      }
                      if (number < 2) {
                        return 'Minimum 2 people required';
                      }
                      if (number > 100) {
                        return 'Maximum 100 people allowed';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.text),
                      SizedBox(width: 8),
                      Text(
                        'Event Date:',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: AppColors.text,
                                surface: AppColors.background,
                                onSurface: AppColors.main,
                              ),
                              dialogBackgroundColor: AppColors.background,
                            ),
                            child: child!,
                          );
                        },
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
              onPressed: () {
                _nameController.clear();
                _peopleController.text = '2';
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.text),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addEvent(
                    new Event(
                      eventId: "E${widget.events.length + 1}",
                      title: "Event E${widget.events.length + 1}",
                      userId: ['U1','U2'],
                      date: DateFormat('d MMMM yyyy').format(DateTime.now()),
                      time: DateFormat('h:mm a').format(DateTime.now()), 
                    )
                  );
                  Navigator.pop(context);
                  
                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Event created successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(
                'Create',
                style: TextStyle(color: AppColors.text),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event) {
    //TODO: handle delete events in firebase
    // setState(() {
    //   widget.events.removeWhere((e) => e.id == event.id);
    // });
    // // Save the updated events list
    // widget.onEventUpdated(event);
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event deleted'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addEvent(Event event) {
    final handler = FirebaseHandler();
    setState(() {
      handler.createEvent(event);
      widget.events.add(event);
    });

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
            style: const TextStyle(
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
              if (widget.events.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_note,
                        size: 64,
                        color: AppColors.main.withOpacity(0.5),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No events yet.\nTap + to create a new event!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.main,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              else
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
                        onDelete: () => _deleteEvent(event),
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