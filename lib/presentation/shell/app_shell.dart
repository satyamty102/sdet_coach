import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  static const _destinations = [
    (
      label: 'Dashboard',
      icon: Icons.space_dashboard_outlined,
      path: '/dashboard',
    ),
    (label: 'Plan', icon: Icons.calendar_month_outlined, path: '/plan'),
    (label: 'Learn', icon: Icons.menu_book_outlined, path: '/learn'),
    (label: 'Mock', icon: Icons.record_voice_over_outlined, path: '/mock'),
    (label: 'Progress', icon: Icons.insights_outlined, path: '/progress'),
  ];

  int _index(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _destinations.indexWhere(
      (item) => location.startsWith(item.path),
    );
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return Scaffold(
          appBar: AppBar(
            title: const Text('SDET COACH'),
            actions: [
              IconButton(
                onPressed: () {},
                tooltip: 'Toggle theme',
                icon: const Icon(Icons.brightness_6_outlined),
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: wide ? null : const _CoachDrawer(),
          body: Row(
            children: [
              if (wide) const SizedBox(width: 240, child: _CoachDrawer()),
              Expanded(child: child),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index(context),
                  onDestinationSelected: (index) =>
                      context.go(_destinations[index].path),
                  destinations: _destinations
                      .map(
                        (item) => NavigationDestination(
                          icon: Icon(item.icon),
                          label: item.label,
                        ),
                      )
                      .toList(),
                ),
        );
      },
    );
  }
}

class _CoachDrawer extends StatelessWidget {
  const _CoachDrawer();

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).uri.path;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'YOUR EDGE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          for (final item in AppShell._destinations)
            ListTile(
              selected: current.startsWith(item.path),
              leading: Icon(item.icon),
              title: Text(item.label),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () => context.go(item.path),
            ),
          const Divider(height: 32),
          ListTile(
            leading: Icon(Icons.tune_outlined),
            title: Text('Skill assessment'),
            onTap: () => context.go('/assessment'),
          ),
          const ListTile(
            leading: Icon(Icons.rule_outlined),
            title: Text('Scenario lab'),
          ),
          const ListTile(
            leading: Icon(Icons.code_outlined),
            title: Text('Coding lab'),
          ),
        ],
      ),
    );
  }
}
