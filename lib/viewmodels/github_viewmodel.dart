import 'package:flutter/foundation.dart';
import '../models/github_model.dart';
import '../repositories/github_repository.dart';

class GithubViewModel extends ChangeNotifier {
  final GithubRepository _repo = GithubRepository();
  GithubModel? _user;
  bool _loading = false;

  GithubModel? get user => _user;
  bool get loading => _loading;

  Future<void> fetchUser(String username) async {
    _loading = true;
    notifyListeners();

    _user = await _repo.getUserData(username);

    _loading = false;
    notifyListeners();
  }
}
