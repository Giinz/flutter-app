import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_new_app/constants/routes.dart';
import 'package:flutter_new_app/helpers/loading/loading_screen.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_event.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_state.dart';
import 'package:flutter_new_app/services/auth/firebase_auth_provider.dart';
import 'package:flutter_new_app/view/login_view.dart';
import 'package:flutter_new_app/view/notes/create_update_note_view.dart';
import 'package:flutter_new_app/view/notes/note_view.dart';
import 'package:flutter_new_app/view/register_view.dart';
import 'package:flutter_new_app/view/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {createUpdateNoteRoute: (context) => const CreateUpdateNoteView()},
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment!',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
