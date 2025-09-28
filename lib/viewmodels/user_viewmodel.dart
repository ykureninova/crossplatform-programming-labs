import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserViewModel {
  final UserRepository _repo = UserRepository();

  List<UserModel> get users => _repo.getAll();
}
