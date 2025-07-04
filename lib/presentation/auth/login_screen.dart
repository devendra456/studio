import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:studio/application/auth/auth_service.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/core/show_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final AuthService _authService = getIt<AuthService>();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.signInWithGoogle();
    
    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
        ShowMessage.show(context, failure.message);
      },
      (user) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, Navigator.defaultRouteName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Logo/Icon
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Hero(
                      tag: 'app_logo',
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.photo_library_rounded,
                          size: 60,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // App Name
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Studio',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // App Description
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Your personal gallery of high-quality images',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  SizedBox(height: size.height * 0.08),
                  
                  // Sign In Button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : _buildGoogleSignInButton(isDarkMode),
                  ),
                  const SizedBox(height: 24),
                  
                  // Terms and Privacy Policy
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'By signing in, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(bool isDarkMode) {
    return  SignInButton(
      Buttons.google,
      text: "Sign up with Google",
      onPressed: _signInWithGoogle,
    );
  }
}