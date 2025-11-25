import 'package:flutter/foundation.dart';
import '../models/github_model.dart';
import '../repositories/github_repository.dart';

class GithubViewModel extends ChangeNotifier {
  final GithubRepository _repo = GithubRepository();

  bool _loading = false;
  GithubModel? _data;

  bool get loading => _loading;
  GithubModel? get data => _data;

  Future<void> load(String username) async {
    _loading = true;
    notifyListeners();

    _data = await _repo.getUserData(username);

    _loading = false;
    notifyListeners();
  }
}
