import 'package:flutter/material.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  static const groups = [
    (
      'Mobile',
      Icons.phone_android_rounded,
      ['Flutter', 'Dart', 'Offline-first', 'Material 3']
    ),
    (
      'Front-end',
      Icons.web_rounded,
      ['React', 'TypeScript', 'JavaScript', 'UI responsiva']
    ),
    (
      'Back-end & Dados',
      Icons.dns_rounded,
      ['APIs REST', 'Node.js', 'Supabase', 'PostgreSQL', 'Neon']
    ),
    (
      'Ferramentas',
      Icons.build_rounded,
      ['Git', 'GitHub', 'Vercel', 'Figma']
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Habilidades')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
        children: [
          Text(
            'Tecnologias e áreas que fazem parte dos meus projetos.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          ...groups.map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colors.primaryContainer,
                          foregroundColor: colors.primary,
                          child: Icon(group.$2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          group.$1,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          group.$3.map((item) => Chip(label: Text(item))).toList(),
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
