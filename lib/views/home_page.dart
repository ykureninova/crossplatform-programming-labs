import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/user_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = UserViewModel();

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: 0,
              onDestinationSelected: (i) {
                if (i == 0) context.go('/');
                if (i == 1) context.go('/github');
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Головна'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.code),
                  label: Text('GitHub'),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: ListView.builder(
              itemCount: vm.users.length,
              itemBuilder: (context, index) {
                final user = vm.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.avatarPath),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.bio),
                  onTap: () => context.go('/about/$index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
