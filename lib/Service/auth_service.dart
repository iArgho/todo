import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login
  Future<User?> loginUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Login successful for user: ${userCredential.user?.email}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        default:
          errorMessage =
              'Login failed: ${e.message ?? 'An unknown error occurred'}';
      }
      print("Login error: $errorMessage");
      throw Exception(errorMessage);
    } catch (e) {
      print("Unexpected login error: $e");
      throw Exception('Unexpected error during login: $e');
    }
  }

  // Register
  Future<User?> registerUser(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(name);
      print("Registration successful for user: ${userCredential.user?.email}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage =
              'Registration failed: ${e.message ?? 'An unknown error occurred'}';
      }
      print("Registration error: $errorMessage");
      throw Exception(errorMessage);
    } catch (e) {
      print("Unexpected registration error: $e");
      throw Exception('Unexpected error during registration: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    print("User logged out");
  }
}
