import 'package:flutter/material.dart';
import 'event_details.dart';
import 'app_colors.dart';
import 'event_model.dart';
import 'tilebutton.dart';
class EventsPage extends StatefulWidget {
  final Function(Event) onEventAdded;
  
  const EventsPage({Key? key, required this.onEventAdded}) : super(key: key);
  
  @override
  _EventsPageState createState() => _EventsPageState();
}


class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];

  void _showCreateEventDialog() {
    String eventName = '';
    int numberOfPeople = 2;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Create New Event',
            style: TextStyle(color: AppColors.text),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
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
                ),
                onChanged: (value) => eventName = value,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Number of People: ',
                    style: TextStyle(color: AppColors.main),
                  ),
                  DropdownButton<int>(
                    dropdownColor: AppColors.subAlt,
                    value: numberOfPeople,
                    items: List.generate(10, (index) => index + 2)
                        .map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: TextStyle(color: AppColors.main),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        numberOfPeople = value ?? 2;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () async {
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
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Text(
                  'Date: ${selectedDate.toString().split(' ')[0]}',
                  style: TextStyle(color: AppColors.text),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.text),
              ),
            ),
            TextButton(
              onPressed: () {
                if (eventName.isNotEmpty) {
                  final newEvent = Event(
                    name: eventName,
                    date: selectedDate,
                    numberOfPeople: numberOfPeople,
                  );
                  setState(() {
                    events.add(newEvent);
                  });
                  widget.onEventAdded(newEvent);
                  Navigator.pop(context);
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
              // Event List
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TileButton(
                      text: "${event.name}\n${event.date.toString().split(' ')[0]}\n${event.numberOfPeople} People",
                      icon: Icons.event,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // Floating Action Button
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  backgroundColor: AppColors.text,
                  onPressed: _showCreateEventDialog,
                  child: Icon(Icons.add, color: AppColors.main),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

