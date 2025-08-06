import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();

  List<UserModel> _users = [];
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  List<UserModel> get users => _users;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsers({String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _repository.getUsers(search: search);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _repository.getCurrentUser();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      return await _repository.getUsers(search: query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? position,
    String? bio,
    String? linkedinProfile,
    String? website,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _repository.updateProfile(
        name: name,
        phone: phone,
        position: position,
        bio: bio,
        linkedinProfile: linkedinProfile,
        website: website,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
