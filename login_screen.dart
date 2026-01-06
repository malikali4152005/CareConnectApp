import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/dashboard_screen.dart';
import '../screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);

    final user = await AuthService.login(_email.trim(), _password);

    setState(() => _loading = false);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F9D9A), Color(0xFF1A73E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Logo
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.local_hospital,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Title
                      Text(
                        'CareConnect',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Secure Medical Access',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Email
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            v == null || !v.contains('@') ? 'Enter a valid email' : null,
                        onSaved: (v) => _email = v!,
                      ),

                      const SizedBox(height: 16),

                      /// Password
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: true,
                        validator: (v) =>
                            v == null || v.length < 4 ? 'Password too short' : null,
                        onSaved: (v) => _password = v!,
                      ),

                      const SizedBox(height: 24),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _login,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ),

                      const SizedBox(height: 16),

                      /// Register
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        ),
                        child: const Text(
                          "Don't have an account? Register",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
