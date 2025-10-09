import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinolive_mobile/design/colors.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Create logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging in...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text('Login',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(
              color: colorScheme.onSurface,
            )),
          const SizedBox(height: 8),
          Text(
            'Enter your email and password to log in',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 60),

          // Email
          Text(
            'Email',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (v) =>
            (v == null || v.isEmpty) ? 'Enter your email' : null,
          ),
          const SizedBox(height: 20),

          // Password
          Text(
            'Password',
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            validator: (v) =>
            (v == null || v.length < 6) ? 'Min 6 characters' : null,
          ),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Recover Password
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                'Forgot Password?',
                style: textTheme.bodyMedium?.copyWith(
                  color: myBlue,
                  decoration: TextDecoration.underline,
                  decorationColor: myBlue,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Login button
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: _onLogin,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: colorScheme.primaryContainer,
              ),
              child: Text('Login', style: TextStyle(color: colorScheme.onPrimaryContainer),),
            ),
          ),

          const SizedBox(height: 30),

          // Divider with "Or"
          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outline)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('Or',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onSurface)),
              ),
              Expanded(child: Divider(color: colorScheme.outline)),
            ],
          ),

          const SizedBox(height: 28),

          // Google button
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                // TODO: sign in with Google
              },
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(color: colorScheme.onSurface),
                foregroundColor: colorScheme.onSurface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.g_mobiledata, size: 28);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text('Login with Google'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ",
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant)),
              TextButton(
                onPressed: () {
                  context.push('/register');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Sign up', style: TextStyle(color: myBlue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}