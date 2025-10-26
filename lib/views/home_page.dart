import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UserViewModel>(context);

    if (!vm.loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Головна')),
                NavigationRailDestination(icon: Icon(Icons.code), label: Text('GitHub')),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Список резюме',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/resume_form'),
                        icon: const Icon(Icons.add),
                        label: const Text('Створити нове'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.users.length,
                    itemBuilder: (context, index) {
                      final user = vm.users[index];
                      final isDefault = index < 3;

                      ImageProvider avatar() {
                        final p = user.avatarPath;
                        if (p.startsWith('assets/')) return AssetImage(p);
                        if (File(p).existsSync()) return FileImage(File(p));
                        return const AssetImage('assets/photo1.jpg');
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: avatar()),
                          title: Text(user.name),
                          subtitle: Text(user.bio),
                          onTap: () => context.go('/about/$index'),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              if (!isDefault)
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () =>
                                      context.push('/resume_form', extra: {'index': index}),
                                ),
                              IconButton(
                                icon: const Icon(Icons.copy, color: Colors.orangeAccent),
                                onPressed: () {
                                  vm.duplicateUser(index);
                                  final newIndex = vm.users.length - 1;
                                  context.push('/resume_form', extra: {'index': newIndex});
                                },
                              ),
                              if (!isDefault)
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Підтвердіть видалення'),
                                        content: Text('Видалити резюме ${user.name}?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Скасувати')),
                                          TextButton(
                                              onPressed: () {
                                                vm.deleteUser(index);
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Видалити',
                                                  style: TextStyle(color: Colors.redAccent))),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
