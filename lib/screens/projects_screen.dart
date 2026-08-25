import 'package:flutter/material.dart';

import '../models/portfolio_data.dart';

class ProjectsScreen extends StatefulWidget {
  final List<PortfolioProject> projects;
  final ValueChanged<PortfolioProject> onProjectTap;

  const ProjectsScreen({
    super.key,
    required this.projects,
    required this.onProjectTap,
  });

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String selected = 'Todos';

  @override
  Widget build(BuildContext context) {
    final types = widget.projects
        .map((project) => project.type)
        .where((value) => value.trim().isNotEmpty)
        .toSet()
        .toList();

    final filters = ['Todos', ...types];

    final filtered = selected == 'Todos'
        ? widget.projects
        : widget.projects.where((p) => p.type == selected).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 125),
      children: [
        Text('Projetos', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 4),
        Text(
          'Conheça alguns dos meus trabalhos e soluções desenvolvidas.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final label = filters[index];
              return ChoiceChip(
                selected: label == selected,
                label: Text(label),
                onSelected: (_) => setState(() => selected = label),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        if (filtered.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Nenhum projeto nessa categoria.'),
            ),
          )
        else
          ...filtered.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ProjectListTile(
                project: project,
                onTap: () => widget.onProjectTap(project),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProjectListTile extends StatelessWidget {
  final PortfolioProject project;
  final VoidCallback onTap;

  const _ProjectListTile({
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 102,
                  height: 102,
                  child: project.imageUrl != null &&
                          project.imageUrl!.isNotEmpty
                      ? Image.network(
                          project.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _cover(project, colors),
                        )
                      : _cover(project, colors),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.type,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (project.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Chip(label: Text(project.tags.first)),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cover(PortfolioProject project, ColorScheme colors) {
    return Container(
      color: project.accent,
      alignment: Alignment.center,
      child: const Icon(
        Icons.code_rounded,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}
