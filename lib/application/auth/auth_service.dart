import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dartz/dartz.dart';
import '../core/failure.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = kIsWeb
      ? GoogleSignIn(
          clientId:
              "946778946960-99f6lgm6tkmc7q3i6nrod708o7jbhrvl.apps.googleusercontent.com",
        )
      : GoogleSignIn();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Left(Failure(500, 'Sign in aborted by user'));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with credential
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return Right(userCredential.user!);
    } catch (e) {
      return Left(
        Failure(500, 'Failed to sign in with Google: ${e.toString()}'),
      );
    }
  }

  // Sign out
  Future<Either<Failure, void>> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Failure(500, 'Failed to sign out: ${e.toString()}'));
    }
  }

  // Check if user is signed in
  bool isSignedIn() {
    return currentUser != null;
  }

  // Get user display name
  String? getUserDisplayName() {
    return currentUser?.displayName;
  }

  // Get user email
  String? getUserEmail() {
    return currentUser?.email;
  }

  // Get user photo URL
  String? getUserPhotoUrl() {
    return currentUser?.photoURL;
  }
}
