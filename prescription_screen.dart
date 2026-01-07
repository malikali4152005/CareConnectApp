import 'package:flutter/material.dart';
import '../services/prescription_service.dart';


class PrescriptionScreen extends StatelessWidget {
final int appointmentId;
PrescriptionScreen({required this.appointmentId});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text('Prescription')),
body: FutureBuilder(
future: PrescriptionService.getByAppointment(appointmentId),
builder: (ctx, snap) {
if (!snap.hasData) return Center(child: CircularProgressIndicator());
final list = snap.data as List;
if (list.isEmpty) return Center(child: Text('No prescription available'));
final p = list.first;
return Padding(
padding: const EdgeInsets.all(16.0),
child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
Text('Doctor: ${p.doctorName}', style: TextStyle(fontWeight: FontWeight.bold)),
SizedBox(height: 8),
Text('Medicines: ${p.medicines}'),
SizedBox(height: 8),
Text('Instructions: ${p.instructions}'),
]),
);
},
),
);
}
}