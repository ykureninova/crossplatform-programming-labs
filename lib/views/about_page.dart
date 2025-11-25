import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/github_viewmodel.dart';
import '../models/user_model.dart';

class AboutPage extends StatefulWidget {
  final int index;
  const AboutPage({super.key, required this.index});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();

    final users = Provider.of<UserViewModel>(context, listen: false).users;
    final user = users[widget.index];

    String extractUsername(String url) {
      if (url.contains("github.com/")) {
        return url.split("github.com/").last.trim();
      }
      return url.trim();
    }

    final username = extractUsername(user.github);

    if (username.isNotEmpty) {
      Provider.of<GithubViewModel>(context, listen: false).load(username);
    }
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не вдалося відкрити посилання')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserViewModel>(context);
    final gh = Provider.of<GithubViewModel>(context);

    if (!vm.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (widget.index < 0 || widget.index >= vm.users.length) {
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

    final user = vm.users[widget.index];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                if (i == 1) context.go('/about/${widget.index}');
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Головна')),
                NavigationRailDestination(
                    icon: Icon(Icons.person), label: Text('Деталі')),
              ],
            ),
          ),

          const VerticalDivider(thickness: 1, width: 1),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(radius: 60, backgroundImage: _avatarFor(user)),
                          const SizedBox(height: 20),
                          Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(user.bio, style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    const Divider(),
                    const Text(
                      "Контактна інформація",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(user.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(user.phone),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(user.location),
                    ),

                    if (user.linkedin.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.link),
                        title: InkWell(
                          onTap: () => _openLink(context, user.linkedin),
                          child: Text(
                            user.linkedin,
                            style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),

                    if (user.github.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: InkWell(
                          onTap: () => _openLink(context, user.github),
                          child: Text(
                            user.github,
                            style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),

                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      "GitHub статистика",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    if (gh.loading)
                      const Center(child: CircularProgressIndicator())
                    else if (gh.data != null)
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(gh.data!.avatarUrl),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                gh.data!.login,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (gh.data!.bio.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(gh.data!.bio),
                                ),
                              const SizedBox(height: 10),
                              Text("Публічні репозиторії: ${gh.data!.publicRepos}"),
                              Text("Підписники: ${gh.data!.followers}"),
                              Text("Підписки: ${gh.data!.following}"),
                            ],
                          ),
                        ),
                      )
                    else
                      const Text("Не вдалося завантажити дані"),

                    const Divider(),
                    const Text(
                      "Освіта",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    ...user.education
                        .map((e) => ListTile(
                              leading: const Icon(Icons.school),
                              title: Text(e),
                            )),

                    const Divider(),
                    const Text(
                      "Досвід роботи",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ...user.experience
                        .map((e) => ListTile(
                              leading: const Icon(Icons.work),
                              title: Text(e),
                            )),

                    const Divider(),
                    const Text(
                      "Навички",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      children: user.skills
                          .map((s) => Chip(label: Text(s)))
                          .toList(),
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
