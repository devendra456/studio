import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studio/application/auth/auth_service.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/presentation/auth/login_screen.dart';
import 'package:studio/presentation/on_boarding/views/on_boarding_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = getIt<AuthService>();

    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // If the snapshot has user data, then they're already signed in
        if (snapshot.hasData && snapshot.data != null) {
          return const OnBoardingScreen();
        }
        
        // Otherwise, they're not signed in
        return const LoginScreen();
      },
    );
  }
}