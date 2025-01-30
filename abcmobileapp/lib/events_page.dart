// events_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'event_details.dart';
import 'app_colors.dart';
import 'model.dart';
import 'tilebutton.dart';
import 'package:intl/intl.dart';


class EventsPage extends StatefulWidget {
  final List<Event> events;
  final Function() onEventUpdated;

  const EventsPage({
    Key? key,
    required this.events,
    required this.onEventUpdated,
  }) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _peopleController = TextEditingController();
  final _nameController = TextEditingController();

  int numberOfUsers = 1; // Default number of users
  double amount = 0;
  bool isEvenSplit = true;
  final List<TextEditingController> costControllers = [];
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final List<TextEditingController> participantControllers = [
    TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
    widget.onEventUpdated();
  }

  @override
  void dispose() {
    _peopleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _addParticipantField() {}

  void _removeParticipantField(int index) {
    if (participantControllers.length > 1) {
      setState(() {
        participantControllers[index].dispose();
        participantControllers.removeAt(index);
      });
    }
  }

  void _showEventForm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String? titleErrorMessage;
          String? participantErrorMessage;
          return StatefulBuilder(builder: (context, setState) {
            bool validateTitle() {
              if (titleController.text == '') {
                setState(() {
                  titleErrorMessage = 'Event title cannot be empty';
                });
                return false;
              }
              setState(() {
                titleErrorMessage = null;
              });
              return true;
            }

            bool validateParticipant() {
              List<String> participants = participantControllers
                  .map((controller) => controller.text)
                  .toList();
              for (var p in participants) {
                if (p == '') {
                  setState(() {
                    participantErrorMessage = 'User ID cannot be empty';
                  });
                  return false;
                }
                

              }
              return true;
            }

            return AlertDialog(
              title: const Text('Add Event'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Title'),
                      controller: titleController,
                    ),
                    const SizedBox(height: 8),
                    if (titleErrorMessage != null)
                      Text(
                        titleErrorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: participantControllers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: participantControllers[index],
                                    decoration: InputDecoration(
                                        labelText: 'Participant ID${index + 1}'),
                                  ),
                                ),
                                if (participantControllers.length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _removeParticipantField(index);
                                      });
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (participantErrorMessage != null)
                      Text(
                        participantErrorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          participantControllers.add(TextEditingController());
                        });
                      },
                      child: const Text('Add Participant'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (validateTitle() && validateParticipant()) {
                      List<String> initialBalances = [];
                      for (var i = 0; i < participantControllers.length; i++) {
                        initialBalances.add(createRepeatingPattern(
                            "0,", participantControllers.length));
                      }

                      _addEvent(new Event(
                        eventId: "${generateUuid()}",
                        title: titleController.text,
                        totalSpending: 0.0,
                        balance: initialBalances,
                        date: DateFormat('d MMMM yyyy').format(DateTime.now()),
                        time: DateFormat('h:mm a').format(DateTime.now()),
                        userId: participantControllers
                            .map((controller) => controller.text)
                            .toList(),
                      ));
                      titleController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          });
        });
  }

  void _deleteEvent(Event event) {
    final handler = FirebaseHandler();
    setState(() {
      handler.deleteEvent(event);
      widget.events.removeWhere((e) => e.eventId == event.eventId);
    });
    // Save the updated events list
    widget.onEventUpdated();

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
                        text:
                            "${event.title}\n${event.date}\n${event.userId.length} People",
                        icon: Icons.event,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsPage(
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
                  onPressed: _showEventForm,
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
