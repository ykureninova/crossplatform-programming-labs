import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/user_viewmodel.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/about') return 1;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/about');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = UserViewModel();
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 250),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _onDestinationSelected(context, index),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Головна'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Про мене'),
                ),
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
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/me.jpg'),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      vm.user.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      vm.user.bio,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.school),
                      title: Text("Студентка ХПІ"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.computer),
                      title: Text(
                        "Навчально-науковий інститут комп'ютерного моделювання, прикладної фізики та математики",
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text("Польща, Торунь"),
                    ),
                    const Divider(),

                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Email: kureninova.liza@gmail.com")),
                        );
                      },
                      icon: const Icon(Icons.email),
                      label: const Text("Зв’язатися"),
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
