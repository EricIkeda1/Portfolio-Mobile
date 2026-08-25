import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Formação')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.school_rounded,
                  size: 38,
                  color: colors.onPrimaryContainer,
                ),
                const SizedBox(height: 18),
                Text(
                  'Engenharia de Software',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 7),
                Text(
                  'UniSenaiPR',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '2021 — 2026',
                  style: TextStyle(
                    color: colors.onPrimaryContainer.withValues(alpha: .75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Minha jornada',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const _TimelineItem(
            year: '2021',
            title: 'Início da graduação',
            text:
                'Começo da formação em Engenharia de Software e contato mais profundo com programação, algoritmos e arquitetura.',
            first: true,
          ),
          const _TimelineItem(
            year: '2023',
            title: 'Web, mobile e back-end',
            text:
                'Aprofundamento em desenvolvimento de aplicações, APIs, banco de dados e construção de projetos completos.',
          ),
          const _TimelineItem(
            year: '2025',
            title: 'Projetos e prática',
            text:
                'Aplicação dos conhecimentos em projetos próprios, interfaces responsivas e soluções integradas com banco de dados.',
          ),
          const _TimelineItem(
            year: '2026',
            title: 'Conclusão do curso',
            text:
                'Graduação concluída, consolidando conhecimentos em desenvolvimento, arquitetura, qualidade, segurança e dados.',
            last: true,
          ),
          const SizedBox(height: 24),
          Text(
            'Principais áreas estudadas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Arquitetura')),
              Chip(label: Text('Front-end')),
              Chip(label: Text('Back-end')),
              Chip(label: Text('Mobile')),
              Chip(label: Text('Banco de dados')),
              Chip(label: Text('APIs')),
              Chip(label: Text('Qualidade')),
              Chip(label: Text('Segurança')),
              Chip(label: Text('Cloud')),
              Chip(label: Text('IA aplicada')),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String text;
  final bool first;
  final bool last;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.text,
    this.first = false,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 62,
            child: Column(
              children: [
                if (!first)
                  Expanded(
                    child: Container(width: 2, color: colors.outlineVariant),
                  )
                else
                  const Spacer(),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(width: 2, color: colors.outlineVariant),
                  )
                else
                  const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      year,
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium,
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
