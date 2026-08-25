import 'package:flutter/material.dart';

import '../models/github_status.dart';
import '../services/external_link_service.dart';

class GitHubScreen extends StatelessWidget {
  final GitHubStatus? status;

  const GitHubScreen({
    super.key,
    required this.status,
  });


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final current = status;

    return Scaffold(
      appBar: AppBar(title: const Text('GitHub')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          if (current == null)
            _Unavailable(colors: colors)
          else ...[
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: colors.inverseSurface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundImage: current.avatarUrl.isNotEmpty
                            ? NetworkImage(current.avatarUrl)
                            : null,
                        child: current.avatarUrl.isEmpty
                            ? const Icon(Icons.code_rounded)
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${current.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: colors.onInverseSurface),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              current.statusLabel,
                              style: TextStyle(
                                color: colors.inversePrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: current.isRecentlyActive
                              ? const Color(0xFF34A853)
                              : colors.inversePrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    current.activityDescription,
                    style: TextStyle(
                      color: colors.onInverseSurface.withValues(alpha: .78),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    value: '${current.publicRepos}',
                    label: 'Repositórios',
                    icon: Icons.folder_open_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Stat(
                    value: '${current.followers}',
                    label: 'Seguidores',
                    icon: Icons.people_alt_outlined,
                  ),
                ),
              ],
            ),
            if (current.lastRepository != null &&
                current.lastRepository!.isNotEmpty) ...[
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colors.primaryContainer,
                      foregroundColor: colors.primary,
                      child: const Icon(Icons.commit_rounded),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Atividade mais recente',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            current.lastRepository!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () => ExternalLinkService.openUrl(
                context,
                current.profileUrl,
                errorMessage: 'Não foi possível abrir o GitHub.',
              ),
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('Abrir perfil no GitHub'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _Stat({
    required this.value,
    required this.label,
    required this.icon,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(height: 18),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  final ColorScheme colors;

  const _Unavailable({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 31,
            backgroundColor: colors.surfaceContainerHigh,
            child: const Icon(Icons.cloud_off_rounded),
          ),
          const SizedBox(height: 16),
          Text(
            'GitHub indisponível',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Não foi possível carregar os dados públicos neste momento.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
