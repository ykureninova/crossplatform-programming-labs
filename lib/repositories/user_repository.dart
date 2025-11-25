import 'dart:convert';
import '../models/user_model.dart';
import '../services/shared_prefs_service.dart';

class UserRepository {
  final SharedPrefsService _prefs = SharedPrefsService();

  final List<UserModel> _defaultUsers = const [
    UserModel(
      name: "Єлизавета Куренінова",
      bio: "Студентка НТУ ХПІ",
      avatarPath: "assets/photo1.jpg",
      location: "Польща, Торунь",
      email: "kureninova.liza@gmail.com",
      phone: "+48 517 111 222",
      linkedin: "linkedin.com/in/yelyzaveta-kureninova",
      github: "github.com/ykureninova",
      education: [
        "ХПІ, Інститут комп'ютерного моделювання, прикладної фізики та математики",
      ],
      experience: [
        "Немає досвіду роботи"
      ],
      skills: ["C++", "SQL", "Phyton", "Git"],
    ),
    UserModel(
      name: "Іван Петренко",
      bio: "Розробник Flutter",
      avatarPath: "assets/photo2.jpg",
      location: "Україна, Київ",
      email: "ivan.petrenko@example.com",
      phone: "+38 093 555 44 33",
      linkedin: "linkedin.com/in/ivanpetrenko",
      github: "github.com/ivanpetrenko",
      education: [
        "КПІ, Факультет інформатики та обчислювальної техніки"
      ],
      experience: [
        "Flutter Developer – EPAM Systems",
        "Backend Intern – Luxoft"
      ],
      skills: ["Flutter", "Dart", "Node.js", "SQL", "REST API"],
    ),
    UserModel(
      name: "Марія Коваленко",
      bio: "Дизайнер UI/UX",
      avatarPath: "assets/photo3.jpg",
      location: "Україна, Львів",
      email: "maria.kovalenko@example.com",
      phone: "+38 067 888 77 66",
      linkedin: "linkedin.com/in/maria-kovalenko",
      github: "github.com/mariakovalenko",
      education: [
        "ЛНУ, Факультет прикладної математики та інформатики"
      ],
      experience: [
        "UI/UX Designer – Freelance",
        "Product Designer – StartupHub"
      ],
      skills: ["Figma", "Adobe XD", "Sketch", "UI Design", "Prototyping"],
    ),
  ];

  Future<List<UserModel>> loadUsers() async {
    final list = await _prefs.loadStringList('users');
    if (list == null) return _defaultUsers;

    return list.map((s) => _fromJson(json.decode(s))).toList();
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final encoded = users.map((u) => json.encode(_toJson(u))).toList();
    await _prefs.saveStringList('users', encoded);
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
        name: m['name'],
        bio: m['bio'],
        avatarPath: m['avatarPath'],
        location: m['location'],
        email: m['email'],
        phone: m['phone'],
        linkedin: m['linkedin'],
        github: m['github'],
        education: (m['education'] as List).cast<String>(),
        experience: (m['experience'] as List).cast<String>(),
        skills: (m['skills'] as List).cast<String>(),
      );
}
