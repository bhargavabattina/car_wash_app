import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _verificationId;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<void> sendOTP(String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    await _authService.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        _verificationId = verificationId;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
        throw error;
      },
    );
  }

  Future<bool> verifyOTP(String otp, String name, String userType) async {
    if (_verificationId == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final credential = await _authService.verifyOTP(
        verificationId: _verificationId!,
        otp: otp,
      );

      if (credential != null && credential.user != null) {
        final existingUser = await _firestoreService.getUser(credential.user!.uid);

        if (existingUser == null) {
          final newUser = UserModel(
            id: credential.user!.uid,
            name: name,
            phone: credential.user!.phoneNumber ?? '',
            userType: userType,
            createdAt: DateTime.now(),
          );
          await _firestoreService.createUser(newUser);
          _currentUser = newUser;
        } else {
          _currentUser = existingUser;
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadCurrentUser() async {
    final userId = _authService.getCurrentUserId();
    if (userId != null) {
      _currentUser = await _firestoreService.getUser(userId);
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser != null) {
      await _firestoreService.updateUser(_currentUser!.id, data);
      await loadCurrentUser();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
