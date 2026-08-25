import 'package:flutter/material.dart';

import '../models/portfolio_data.dart';

class ProjectCard extends StatelessWidget {
  final PortfolioProject project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: colors.surfaceContainerLowest,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 150,
              child: project.imageUrl != null && project.imageUrl!.isNotEmpty
                  ? Image.network(
                      project.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _ProjectCover(project: project),
                    )
                  : _ProjectCover(project: project),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    project.type,
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      if (project.tags.isNotEmpty)
                        Flexible(
                          child: Chip(label: Text(project.tags.first)),
                        ),
                      const Spacer(),
                      Icon(
                        Icons.open_in_new_rounded,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCover extends StatelessWidget {
  final PortfolioProject project;

  const _ProjectCover({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: project.accent,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              project.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.code_rounded,
              color: Colors.white70,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}
