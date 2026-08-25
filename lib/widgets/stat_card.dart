import 'package:flutter/material.dart';

class StatItem {
  final IconData icon;
  final String value;
  final String label;

  const StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
}

class StatCard extends StatelessWidget {
  const StatCard({super.key});

  static const _items = [
    StatItem(
      icon: Icons.code_rounded,
      value: '+10',
      label: 'Projetos\nconcluídos',
    ),
    StatItem(
      icon: Icons.rocket_launch_rounded,
      value: '+2',
      label: 'Anos de\nexperiência',
    ),
    StatItem(
      icon: Icons.local_cafe_rounded,
      value: '+5k',
      label: 'Horas de\ncódigo',
    ),
    StatItem(
      icon: Icons.star_rounded,
      value: '100%',
      label: 'Dedicação e\nfoco',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: .35),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: index == _items.length - 1
                    ? null
                    : Border(
                        right: BorderSide(
                          color: colors.outlineVariant.withValues(alpha: .55),
                        ),
                      ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      item.icon,
                      color: colors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.value,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
