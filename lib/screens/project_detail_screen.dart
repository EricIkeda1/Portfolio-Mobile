import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';

class ProjectDetailScreen extends StatelessWidget {
  final PortfolioProject project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  Future<void> _openProject(BuildContext context) async {
    final link = project.github.trim();

    if (link.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este projeto não possui um link disponível.'),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(link);

    if (uri == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O link deste projeto é inválido.'),
        ),
      );
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir este projeto.'),
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir este projeto.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
        children: [
          Hero(
            tag: 'project-cover-${project.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: SizedBox(
                height: 220,
                child: project.imageUrl != null && project.imageUrl!.isNotEmpty
                    ? Image.network(
                        project.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _cover(),
                      )
                    : _cover(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            project.name,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 6),
          Text(
            project.type,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.primary,
                ),
          ),
          const SizedBox(height: 14),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (project.highlights.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(
              'Destaques',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...project.highlights.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: colors.primaryContainer,
                      foregroundColor: colors.primary,
                      child: const Icon(Icons.check_rounded, size: 15),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
          ],
          if (project.tags.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.tags
                  .map((item) => Chip(label: Text(item)))
                  .toList(),
            ),
          ],
          if (project.github.isNotEmpty) ...[
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: () => _openProject(context),
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Abrir projeto'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cover() {
    return Container(
      color: project.accent,
      alignment: Alignment.center,
      child: const Icon(
        Icons.code_rounded,
        size: 80,
        color: Colors.white,
      ),
    );
  }
}
