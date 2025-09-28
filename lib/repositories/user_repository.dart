import '../models/user_model.dart';

class UserRepository {
  final List<UserModel> _users = const [
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

  List<UserModel> getAll() => _users;
}
