import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_new_app/constants/routes.dart';
import 'package:flutter_new_app/services/auth/auth_exceptions.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_event.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_state.dart';
import 'package:flutter_new_app/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your email!'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password!'),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is UserNotFoundAuthException) {
                  await showErrorDialog(context, 'User not found!');
                } else if (state.exception is WrongPasswordAuthException) {
                  await showErrorDialog(context, 'Wrong credentials');
                } else if (state.exception is GenericlAuthException) {
                  await showErrorDialog(context, 'Authentiation Error');
                }
              }
            },
            child: TextButton(
              child: const Text('Login'),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                      AuthEventLogin(
                        email,
                        password,
                      ),
                    );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not register yet? Register here'),
          )
        ],
      ),
    );
  }
}
