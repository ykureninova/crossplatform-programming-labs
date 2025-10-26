import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repo = UserRepository();
  final List<UserModel> _users = [];
  bool _loaded = false;

  List<UserModel> get users => List.unmodifiable(_users);
  bool get loaded => _loaded;

  UserViewModel() {
    _init();
  }

  Future<void> _init() async {
    await _loadFromStorage();
    if (_users.isEmpty) {
      _users.addAll(_repo.getAll());
      await _saveToStorage();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _users.map((u) => json.encode(_toJson(u))).toList();
    await prefs.setStringList('users', jsonList);
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('users');
    if (jsonList == null) return;
    _users
      ..clear()
      ..addAll(jsonList.map((s) => _fromJson(json.decode(s))));
  }

  Map<String, dynamic> _toJson(UserModel u) => {
        'name': u.name,
        'bio': u.bio,
        'avatarPath': u.avatarPath,
        'location': u.location,
        'email': u.email,
        'phone': u.phone,
        'linkedin': u.linkedin,
        'github': u.github,
        'education': u.education,
        'experience': u.experience,
        'skills': u.skills,
      };

  UserModel _fromJson(Map<String, dynamic> m) => UserModel(
        name: m['name'] ?? '',
        bio: m['bio'] ?? '',
        avatarPath: m['avatarPath'] ?? 'assets/photo1.jpg',
        location: m['location'] ?? '',
        email: m['email'] ?? '',
        phone: m['phone'] ?? '',
        linkedin: m['linkedin'] ?? '',
        github: m['github'] ?? '',
        education: (m['education'] as List?)?.cast<String>() ?? const [],
        experience: (m['experience'] as List?)?.cast<String>() ?? const [],
        skills: (m['skills'] as List?)?.cast<String>() ?? const [],
      );

  void addUser(UserModel user) {
    _users.add(user);
    _saveToStorage();
    notifyListeners();
  }

  void updateUser(int index, UserModel user) {
    if (index < 0 || index >= _users.length) return;
    _users[index] = user;
    _saveToStorage();
    notifyListeners();
  }

  void deleteUser(int index) {
    if (index < 3) return;
    if (index < 0 || index >= _users.length) return;
    _users.removeAt(index);
    _saveToStorage();
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
    _saveToStorage();
    notifyListeners();
  }
}
