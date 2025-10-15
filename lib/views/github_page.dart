import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/github_viewmodel.dart';
import 'package:go_router/go_router.dart';

class GithubPage extends StatefulWidget {
  const GithubPage({super.key});

  @override
  State<GithubPage> createState() => _GithubPageState();
}

class _GithubPageState extends State<GithubPage> {
  final _controller = TextEditingController();

  Future<void> _openProfile(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не вдалося відкрити посилання')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GithubViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub статистика'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Введіть ім’я користувача GitHub',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final username = _controller.text.trim();
                if (username.isNotEmpty) vm.fetchUser(username);
              },
              child: const Text('Отримати дані'),
            ),
            const SizedBox(height: 20),
            if (vm.loading)
              const CircularProgressIndicator()
            else if (vm.user != null)
              Expanded(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(vm.user!.avatarUrl),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          vm.user!.login,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        if (vm.user!.bio.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(vm.user!.bio),
                          ),
                        const Divider(),
                        Text('Публічні репозиторії: ${vm.user!.publicRepos}'),
                        Text('Підписники: ${vm.user!.followers}'),
                        Text('Підписки: ${vm.user!.following}'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _openProfile(vm.user!.htmlUrl),
                          child: const Text('Відкрити профіль'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
