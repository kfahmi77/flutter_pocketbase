import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.loading) {
          _isButtonEnabled = false;
        } else if (state.status == LoginStatus.success) {
          // Navigate to next screen
        } else {
          _isButtonEnabled = true;
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: state.usernameInvalid ? 'Invalid username' : null,
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: state.passwordInvalid ? 'Invalid password' : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () => context.read<LoginBloc>().add(LoginSubmitted(
                          _usernameController.text, _passwordController.text))
                      : null,
                  child: const Text('Login'),
                ),
                if (state.status == LoginStatus.loading) CircularProgressIndicator(),
                if (state.status == LoginStatus.failure) Text('Login failed'),
                if (state.status == LoginStatus.success) Text('Login successful'),
              ],
            ),
          );
        },
      ),
    );
  }
}
