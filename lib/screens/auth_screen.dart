import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  final AuthService _authService = AuthService();

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    String? error;
    if (_isLogin) {
      error = await _authService.login(email, password);
    } else {
      error = await _authService.signUp(email, password);
    }

    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isLogin ? "Welcome Back" : "Register", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text(_isLogin ? "Login" : "Sign Up")),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin ? "New here? Create account" : "Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}