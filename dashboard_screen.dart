import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'doctors_list_screen.dart';
import 'appointments_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = 'User';
  int _userAge = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _userAge = prefs.getInt('userAge') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('CareConnect'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Header with avatar and user info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade400,
                    child: Text(
                      _userName.isNotEmpty ? _userName[0] : 'U',
                      style: const TextStyle(
                          fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $_userName',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Age: $_userAge',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Menu Cards
            Expanded(
              child: ListView(
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.medical_services,
                    color: Colors.blue,
                    title: 'Find Doctors',
                    subtitle: 'Search doctors by specialization',
                    destination: DoctorsListScreen(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.calendar_today,
                    color: Colors.green,
                    title: 'My Appointments',
                    subtitle: 'View upcoming and past bookings',
                    destination: AppointmentsScreen(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.chat,
                    color: Colors.orange,
                    title: 'Consultation Chat',
                    subtitle: 'Chat with your doctors',
                    destination: ChatScreen(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.person,
                    color: Colors.purple,
                    title: 'Profile & Settings',
                    subtitle: 'Manage your profile and preferences',
                    destination: ProfileScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method for creating menu cards
  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle,
      required Widget destination}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      ),
    );
  }
}
