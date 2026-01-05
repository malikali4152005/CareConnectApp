import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  Future<List<Appointment>>? _appts;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getInt('userId') ?? 1;

    setState(() {
      _appts = AppointmentService.getAppointmentsForUser(uid);
    });
  }

  Future<void> _cancelAppointment(int id) async {
    await AppointmentService.cancelAppointment(id);
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: FutureBuilder<List<Appointment>>(
        future: _appts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found'));
          }

          final appts = snapshot.data!;
          return ListView.builder(
            itemCount: appts.length,
            itemBuilder: (context, i) {
              final a = appts[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Doctor ID: ${a.doctorId}'),
                  subtitle: Text('${a.date} • ${a.time}'),
                  trailing: a.status == 'booked'
                      ? TextButton(
                          onPressed: () => _cancelAppointment(a.id!),
                          child: const Text('Cancel'),
                        )
                      : Text(a.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
