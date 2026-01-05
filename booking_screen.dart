import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/doctor.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class BookingScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _loading = false;

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (d != null) {
      setState(() => _selectedDate = d);
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );

    if (t != null) {
      setState(() => _selectedTime = t);
    }
  }

  Future<void> _confirmBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 1;

      final date =
          '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      final time = _selectedTime!.format(context);

      final appt = Appointment(
        userId: userId,
        doctorId: widget.doctor.id ?? 0,
        date: date,
        time: time,
        status: 'booked',
      );

      await AppointmentService.createAppointment(appt);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'Select appointment date'
        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

    final timeText = _selectedTime == null
        ? 'Select appointment time'
        : _selectedTime!.format(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(title: const Text('Book Appointment'), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Doctor Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      size: 50,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.doctor.specialization),
                    const SizedBox(height: 5),
                    Text('Experience: ${widget.doctor.experience} years'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Date Picker
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Appointment Date'),
                subtitle: Text(dateText),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _pickDate,
              ),
            ),

            const SizedBox(height: 10),

            /// Time Picker
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Appointment Time'),
                subtitle: Text(timeText),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _pickTime,
              ),
            ),

            const SizedBox(height: 30),

            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      'Confirm Booking',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _confirmBooking,
                  ),
          ],
        ),
      ),
    );
  }
}
