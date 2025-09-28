import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/user_viewmodel.dart';

class AboutPage extends StatelessWidget {
  final int index;
  const AboutPage({super.key, required this.index});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/about')) return 1;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int i) {
    if (i == 0) context.go('/');
    if (i == 1) context.go('/about/$index');
  }

  @override
  Widget build(BuildContext context) {
    final vm = UserViewModel();
    final user = vm.users[index];
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 250),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => _onDestinationSelected(context, i),
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
                          CircleAvatar(radius: 60, backgroundImage: AssetImage(user.avatarPath)),
                          const SizedBox(height: 20),
                          Text(user.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          Text(user.bio,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Text("Контактна інформація",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ListTile(leading: const Icon(Icons.email), title: Text(user.email)),
                    ListTile(leading: const Icon(Icons.phone), title: Text(user.phone)),
                    ListTile(leading: const Icon(Icons.link), title: Text(user.linkedin)),
                    ListTile(leading: const Icon(Icons.code), title: Text(user.github)),
                    ListTile(leading: const Icon(Icons.location_on), title: Text(user.location)),
                    const Divider(),
                    const Text("Освіта",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ...user.education.map((e) =>
                        ListTile(leading: const Icon(Icons.school), title: Text(e))),
                    const Divider(),
                    const Text("Досвід роботи",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ...user.experience.map((e) =>
                        ListTile(leading: const Icon(Icons.work), title: Text(e))),
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
