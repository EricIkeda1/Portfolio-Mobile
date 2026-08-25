import 'package:flutter/material.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Experiência')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
        children: [
          Text(
            'Minha experiência vem da construção de aplicações web e mobile, projetos acadêmicos e projetos próprios.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          const _ExperienceCard(
            icon: Icons.phone_android_rounded,
            title: 'Desenvolvimento Mobile',
            description:
                'Criação de aplicativos em Flutter, integração com APIs e bancos de dados, sincronização e interfaces responsivas.',
          ),
          const SizedBox(height: 12),
          const _ExperienceCard(
            icon: Icons.language_rounded,
            title: 'Desenvolvimento Web',
            description:
                'Desenvolvimento de interfaces em React, sistemas administrativos, autenticação e publicação na Vercel.',
          ),
          const SizedBox(height: 12),
          const _ExperienceCard(
            icon: Icons.storage_rounded,
            title: 'Banco de dados e Back-end',
            description:
                'Modelagem e integração com PostgreSQL, Neon e Supabase, além da criação de APIs para aplicações.',
          ),
          const SizedBox(height: 12),
          const _ExperienceCard(
            icon: Icons.school_rounded,
            title: 'Engenharia de Software',
            description:
                'Formação com contato com arquitetura, qualidade, testes, segurança, desenvolvimento mobile, web e back-end.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Text(
              'Esta seção pode virar conteúdo administrável no Neon futuramente, da mesma forma que os projetos e o “Quem sou eu”.',
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ExperienceCard({
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
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 5),
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
