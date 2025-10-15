import '../models/github_model.dart';
import '../services/github_service.dart';

class GithubRepository {
  final GithubService _service = GithubService();

  Future<GithubModel?> getUserData(String username) {
    return _service.fetchUser(username);
  }
}
