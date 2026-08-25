import 'package:flutter/material.dart';

import '../models/portfolio_data.dart';

class AboutScreen extends StatelessWidget {
  final PortfolioSettings settings;

  const AboutScreen({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 125),
      children: [
        Text('Sobre', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 4),
        Text(
          'Quem sou eu e como gosto de trabalhar.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (settings.profileImageUrl != null &&
                    settings.profileImageUrl!.isNotEmpty) ...[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        settings.profileImageUrl!,
                        width: 160,
                        height: 190,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  'Quem sou eu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  settings.aboutText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Áreas de atuação',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const _AboutArea(
          icon: Icons.language_rounded,
          title: 'Full Stack',
          description:
              'Desenvolvimento de aplicações web completas, do banco de dados à interface.',
        ),
        const SizedBox(height: 10),
        const _AboutArea(
          icon: Icons.phone_android_rounded,
          title: 'Mobile',
          description:
              'Aplicações mobile modernas, responsivas e focadas na experiência do usuário.',
        ),
        const SizedBox(height: 10),
        const _AboutArea(
          icon: Icons.dns_rounded,
          title: 'Back-end',
          description:
              'APIs, autenticação, regras de negócio e integração com banco de dados.',
        ),
      ],
    );
  }
}

class _AboutArea extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AboutArea({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colors.primaryContainer,
            foregroundColor: colors.primary,
            child: Icon(icon),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
