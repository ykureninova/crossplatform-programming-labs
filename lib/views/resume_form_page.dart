import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../viewmodels/user_viewmodel.dart';

class ResumeFormPage extends StatefulWidget {
  final int? index;
  const ResumeFormPage({super.key, this.index});

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController bio;
  late TextEditingController location;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController linkedin;
  late TextEditingController github;
  late TextEditingController education;
  late TextEditingController experience;
  late TextEditingController skills;
  String? avatarPath;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<UserViewModel>(context, listen: false);
    if (widget.index != null && widget.index! < vm.users.length) {
      final u = vm.users[widget.index!];
      name = TextEditingController(text: u.name);
      bio = TextEditingController(text: u.bio);
      location = TextEditingController(text: u.location);
      email = TextEditingController(text: u.email);
      phone = TextEditingController(text: u.phone);
      linkedin = TextEditingController(text: u.linkedin);
      github = TextEditingController(text: u.github);
      education = TextEditingController(text: u.education.join(', '));
      experience = TextEditingController(text: u.experience.join(', '));
      skills = TextEditingController(text: u.skills.join(', '));
      avatarPath = u.avatarPath;
    } else {
      name = TextEditingController();
      bio = TextEditingController();
      location = TextEditingController();
      email = TextEditingController();
      phone = TextEditingController();
      linkedin = TextEditingController();
      github = TextEditingController();
      education = TextEditingController();
      experience = TextEditingController();
      skills = TextEditingController();
      avatarPath = null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => avatarPath = picked.path);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final vm = Provider.of<UserViewModel>(context, listen: false);
    final newUser = UserModel(
      name: name.text,
      bio: bio.text,
      avatarPath: avatarPath ?? 'assets/photo1.jpg',
      location: location.text,
      email: email.text,
      phone: phone.text,
      linkedin: linkedin.text,
      github: github.text,
      education: education.text.split(',').map((e) => e.trim()).toList(),
      experience: experience.text.split(',').map((e) => e.trim()).toList(),
      skills: skills.text.split(',').map((e) => e.trim()).toList(),
    );

    if (widget.index != null && widget.index! < vm.users.length) {
      vm.updateUser(widget.index!, newUser);
    } else {
      vm.addUser(newUser);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = (avatarPath == null || avatarPath!.isEmpty)
        ? const AssetImage('assets/photo1.jpg')
        : (avatarPath!.startsWith('assets/')
            ? AssetImage(avatarPath!)
            : FileImage(File(avatarPath!)) as ImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index == null ? 'Нове резюме' : 'Редагування резюме'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: imageProvider,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Натисніть іконку камери, щоб змінити фото',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Ім’я'),
                validator: (v) => v == null || v.isEmpty ? 'Введіть ім’я' : null,
              ),
              TextFormField(
                controller: bio,
                decoration: const InputDecoration(labelText: 'Опис / Біо'),
              ),
              TextFormField(
                controller: location,
                decoration: const InputDecoration(labelText: 'Локація'),
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: phone,
                decoration: const InputDecoration(labelText: 'Телефон'),
              ),
              TextFormField(
                controller: linkedin,
                decoration: const InputDecoration(labelText: 'LinkedIn'),
              ),
              TextFormField(
                controller: github,
                decoration: const InputDecoration(labelText: 'GitHub'),
              ),
              TextFormField(
                controller: education,
                decoration: const InputDecoration(
                    labelText: 'Освіта (через кому)'),
              ),
              TextFormField(
                controller: experience,
                decoration: const InputDecoration(
                    labelText: 'Досвід (через кому)'),
              ),
              TextFormField(
                controller: skills,
                decoration:
                    const InputDecoration(labelText: 'Навички (через кому)'),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text("Зберегти резюме"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
