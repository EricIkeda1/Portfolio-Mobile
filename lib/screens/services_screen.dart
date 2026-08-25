import 'package:flutter/material.dart';

import '../models/portfolio_data.dart';
import 'contact_screen.dart';

class ServicesScreen extends StatelessWidget {
  final PortfolioSettings settings;

  const ServicesScreen({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Serviços')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          Text(
            'Como posso transformar uma ideia em produto.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 22),
          const _ServiceHero(
            number: '01',
            icon: Icons.phone_android_rounded,
            title: 'Aplicativos mobile',
            description:
                'Interfaces em Flutter, integração com APIs, autenticação, dados em tempo real e experiências responsivas.',
          ),
          const SizedBox(height: 14),
          const _ServiceHero(
            number: '02',
            icon: Icons.language_rounded,
            title: 'Aplicações web',
            description:
                'Sites e sistemas modernos, responsivos e organizados, com foco em usabilidade e desempenho.',
          ),
          const SizedBox(height: 14),
          const _ServiceHero(
            number: '03',
            icon: Icons.dns_rounded,
            title: 'Back-end e integração',
            description:
                'APIs, regras de negócio, autenticação e integração com PostgreSQL, Neon, Supabase e outros serviços.',
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tem um projeto em mente?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: colors.onSecondaryContainer,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Podemos conversar sobre a ideia, objetivo e o melhor caminho para desenvolver.',
                  style: TextStyle(
                    color: colors.onSecondaryContainer.withValues(alpha: .82),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ContactScreen(settings: settings),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Entrar em contato'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceHero extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const _ServiceHero({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 74,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: colors.primary),
                const SizedBox(height: 4),
                Text(
                  number,
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 7),
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
