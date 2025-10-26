import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/user_viewmodel.dart';
import '../models/user_model.dart';

class AboutPage extends StatelessWidget {
  final int index;
  const AboutPage({super.key, required this.index});

  ImageProvider _avatarFor(UserModel u) {
    final p = u.avatarPath;
    if (p.isEmpty) return const AssetImage('assets/photo1.jpg');
    if (p.startsWith('assets/')) return AssetImage(p);
    if (File(p).existsSync()) return FileImage(File(p));
    return const AssetImage('assets/photo1.jpg');
  }

  Future<void> _openLink(BuildContext context, String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Не вдалося відкрити посилання')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserViewModel>(context);

    if (!vm.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (index < 0 || index >= vm.users.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Резюме'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(child: Text('Резюме не знайдено')),
      );
    }

    final user = vm.users[index];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 250),
      appBar: AppBar(
        title: const Text('Деталі резюме'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: 1,
              onDestinationSelected: (i) {
                if (i == 0) context.go('/');
                if (i == 1) context.go('/about/$index');
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Головна')),
                NavigationRailDestination(icon: Icon(Icons.person), label: Text('Деталі')),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(radius: 60, backgroundImage: _avatarFor(user)),
                          const SizedBox(height: 20),
                          Text(user.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text(user.bio, style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Text("Контактна інформація",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ListTile(leading: const Icon(Icons.email), title: Text(user.email)),
                    ListTile(leading: const Icon(Icons.phone), title: Text(user.phone)),
                    ListTile(leading: const Icon(Icons.location_on), title: Text(user.location)),
                    if (user.linkedin.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.link),
                        title: InkWell(
                          onTap: () => _openLink(context, user.linkedin),
                          child: Text(user.linkedin,
                              style: const TextStyle(
                                  color: Colors.blue, decoration: TextDecoration.underline)),
                        ),
                      ),
                    if (user.github.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: InkWell(
                          onTap: () => _openLink(context, user.github),
                          child: Text(user.github,
                              style: const TextStyle(
                                  color: Colors.blue, decoration: TextDecoration.underline)),
                        ),
                      ),
                    const Divider(),
                    const Text("Освіта",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ...user.education
                        .map((e) => ListTile(leading: const Icon(Icons.school), title: Text(e))),
                    const Divider(),
                    const Text("Досвід роботи",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ...user.experience
                        .map((e) => ListTile(leading: const Icon(Icons.work), title: Text(e))),
                    const Divider(),
                    const Text("Навички",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: user.skills.map((s) => Chip(label: Text(s))).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
