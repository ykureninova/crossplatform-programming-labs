import 'package:flutter_test/flutter_test.dart';

import '../../lib/viewmodels/user_viewmodel.dart';
import '../../lib/models/user_model.dart';
import '../../lib/repositories/user_repository.dart';

class MockUserRepository extends UserRepository {
  List<UserModel> stored = [];

  @override
  Future<List<UserModel>> loadUsers() async {
    if (stored.isEmpty) {
      return const [
        UserModel(
          name: "Default1",
          bio: "Bio1",
          avatarPath: "assets/photo1.jpg",
          location: "Location1",
          email: "email1",
          phone: "p1",
          linkedin: "l1",
          github: "g1",
          education: ["Edu1"],
          experience: ["Exp1"],
          skills: ["Skill1"],
        ),
        UserModel(
          name: "Default2",
          bio: "Bio2",
          avatarPath: "assets/photo1.jpg",
          location: "Location2",
          email: "email2",
          phone: "p2",
          linkedin: "l2",
          github: "g2",
          education: ["Edu2"],
          experience: ["Exp2"],
          skills: ["Skill2"],
        ),
        UserModel(
          name: "Default3",
          bio: "Bio3",
          avatarPath: "assets/photo1.jpg",
          location: "Location3",
          email: "email3",
          phone: "p3",
          linkedin: "l3",
          github: "g3",
          education: ["Edu3"],
          experience: ["Exp3"],
          skills: ["Skill3"],
        ),
      ];
    }
    return stored;
  }

  @override
  Future<void> saveUsers(List<UserModel> users) async {
    stored = List.from(users);
  }
}

void main() {
  late UserViewModel vm;
  late MockUserRepository mock;

  setUp(() {
    mock = MockUserRepository();
    vm = UserViewModel.withRepository(mock);
  });

  test('initial load loads 3 default users', () async {
    await vm.initForTests();
    expect(vm.users.length, 3);
    expect(vm.users.first.name, "Default1");
  });

  test('addUser adds a new user', () async {
    await vm.initForTests();

    const newUser = UserModel(
      name: "NewUser",
      bio: "Bio",
      avatarPath: "assets/photo1.jpg",
      location: "L",
      email: "e",
      phone: "p",
      linkedin: "l",
      github: "g",
      education: ["e"],
      experience: ["x"],
      skills: ["s"],
    );

    vm.addUser(newUser);

    expect(vm.users.length, 4);
    expect(vm.users.last.name, "NewUser");
  });

  test('updateUser updates existing user', () async {
    await vm.initForTests();

    const updated = UserModel(
      name: "Updated",
      bio: "B2",
      avatarPath: "assets/photo1.jpg",
      location: "L2",
      email: "e2",
      phone: "p2",
      linkedin: "l2",
      github: "g2",
      education: ["e2"],
      experience: ["x2"],
      skills: ["s2"],
    );

    vm.updateUser(0, updated);

    expect(vm.users.first.name, "Updated");
    expect(vm.users.first.location, "L2");
  });

  test('deleteUser removes user at index >= 3', () async {
    await vm.initForTests();

    const removable = UserModel(
      name: "Removable",
      bio: "B",
      avatarPath: "assets/photo1.jpg",
      location: "L",
      email: "e",
      phone: "p",
      linkedin: "l",
      github: "g",
      education: ["e"],
      experience: ["x"],
      skills: ["s"],
    );

    vm.addUser(removable);

    expect(vm.users.length, 4);

    vm.deleteUser(3);

    expect(vm.users.length, 3);
  });

  test('duplicateUser creates a copy', () async {
    await vm.initForTests();

    vm.duplicateUser(0);

    expect(vm.users.length, 4);
    expect(vm.users[3].name, "Default1 (копія)");
  });
}
