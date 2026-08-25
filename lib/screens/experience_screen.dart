import 'package:flutter/material.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Experiência')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          Text(
            'Experiência construída através de projetos reais, estudos e desenvolvimento contínuo.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: colors.tertiaryContainer,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.route_rounded,
                  size: 42,
                  color: colors.onTertiaryContainer,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Do planejamento à entrega: interface, dados, integração e publicação.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.onTertiaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const _JourneyStep(
            icon: Icons.phone_android_rounded,
            title: 'Mobile',
            description:
                'Aplicações em Flutter com interfaces responsivas, integração com APIs, autenticação e estratégias offline-first.',
          ),
          const _JourneyStep(
            icon: Icons.language_rounded,
            title: 'Web',
            description:
                'Interfaces em React e TypeScript, sistemas administrativos e experiências adaptadas para desktop e mobile.',
          ),
          const _JourneyStep(
            icon: Icons.storage_rounded,
            title: 'Back-end e dados',
            description:
                'APIs, PostgreSQL, Neon, Supabase, autenticação e integração entre aplicações e serviços.',
          ),
          const _JourneyStep(
            icon: Icons.rocket_launch_rounded,
            title: 'Deploy e evolução',
            description:
                'Versionamento com Git, publicação na Vercel, correções, melhorias de desempenho e evolução contínua dos projetos.',
            last: true,
          ),
        ],
      ),
    );
  }
}

class _JourneyStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool last;

  const _JourneyStep({
    required this.icon,
    required this.title,
    required this.description,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 54,
          child: Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.primary,
                child: Icon(icon, size: 21),
              ),
              if (!last)
                Container(
                  width: 2,
                  height: 84,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  color: colors.outlineVariant,
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
