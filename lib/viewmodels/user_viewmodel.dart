import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repo;
  final List<UserModel> _users = [];
  bool _loaded = false;

  List<UserModel> get users => List.unmodifiable(_users);
  bool get loaded => _loaded;

  UserViewModel() : _repo = UserRepository() {
    _init();
  }

  UserViewModel.withRepository(this._repo);

  Future<void> initForTests() async {
    await _init();
  }

  Future<void> _init() async {
    final loaded = await _repo.loadUsers();
    _users
      ..clear()
      ..addAll(loaded);

    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    await _repo.saveUsers(_users);
  }

  void addUser(UserModel user) {
    _users.add(user);
    _save();
    notifyListeners();
  }

  void updateUser(int index, UserModel user) {
    if (index < 0 || index >= _users.length) return;
    _users[index] = user;
    _save();
    notifyListeners();
  }

  void deleteUser(int index) {
    if (index < 3) return;
    if (index < 0 || index >= _users.length) return;
    _users.removeAt(index);
    _save();
    notifyListeners();
  }

  void duplicateUser(int index) {
    if (index < 0 || index >= _users.length) return;
    final o = _users[index];
    final copy = UserModel(
      name: '${o.name} (копія)',
      bio: o.bio,
      avatarPath: o.avatarPath,
      location: o.location,
      email: o.email,
      phone: o.phone,
      linkedin: o.linkedin,
      github: o.github,
      education: List<String>.from(o.education),
      experience: List<String>.from(o.experience),
      skills: List<String>.from(o.skills),
    );
    _users.add(copy);
    _save();
    notifyListeners();
  }
}
