class UserModel {
  final String name;
  final String bio;
  final String avatarPath;
  final String location;

  final String email;
  final String phone;
  final String linkedin;
  final String github;

  final List<String> education;
  final List<String> experience;
  final List<String> skills;

  const UserModel({
    required this.name,
    required this.bio,
    required this.avatarPath,
    required this.location,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.github,
    required this.education,
    required this.experience,
    required this.skills,
  });
}
