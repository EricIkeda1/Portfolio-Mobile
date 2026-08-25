import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/github_status.dart';
import '../models/portfolio_data.dart';
import '../widgets/project_card.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  final PortfolioData data;
  final GitHubStatus? githubStatus;
  final VoidCallback onOpenAbout;
  final VoidCallback onOpenProjects;
  final ValueChanged<PortfolioProject> onProjectTap;

  const HomeScreen({
    super.key,
    required this.data,
    required this.githubStatus,
    required this.onOpenAbout,
    required this.onOpenProjects,
    required this.onProjectTap,
  });

  Future<void> _launch(String value) async {
    if (value.isEmpty) return;
    final uri = Uri.tryParse(value);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final settings = data.settings;

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 125),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, eu sou',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displayLarge,
                        children: [
                          const TextSpan(text: 'Eric Y. Ikeda'),
                          TextSpan(
                            text: '.',
                            style: TextStyle(color: colors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Desenvolvedor de Software',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Transformo ideias em projetos reais, criando aplicações web e mobile modernas, rápidas e fáceis de usar.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: onOpenAbout,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Quem sou eu'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _ProfileImage(url: settings.profileImageUrl),
            ],
          ),
          const SizedBox(height: 18),
          _GitHubStatusCard(status: githubStatus),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SocialButton(
                tooltip: 'GitHub',
                icon: Icons.code_rounded,
                onTap: () => _launch(settings.github),
              ),
              _SocialButton(
                tooltip: 'E-mail',
                icon: Icons.mail_outline_rounded,
                onTap: () => _launch('mailto:${settings.email}'),
              ),
              _SocialButton(
                tooltip: 'WhatsApp',
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () {
                  final phone =
                      settings.whatsapp.replaceAll(RegExp(r'[^0-9]'), '');
                  _launch('https://wa.me/55$phone');
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          SectionTitle(
            title: 'Projetos em destaque',
            actionLabel: 'Ver todos',
            onAction: onOpenProjects,
          ),
          const SizedBox(height: 12),
          if (data.projects.isEmpty)
            const _EmptyProjects()
          else
            SizedBox(
              height: 392,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.projects.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: 250,
                  child: ProjectCard(
                    project: data.projects[index],
                    onTap: () => onProjectTap(data.projects[index]),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 30),
          const SectionTitle(title: 'Áreas de atuação'),
          const SizedBox(height: 12),
          const _AreaCard(
            icon: Icons.language_rounded,
            title: 'Full Stack',
            text:
                'Desenvolvimento de aplicações web completas, do banco de dados à interface.',
          ),
          const SizedBox(height: 10),
          const _AreaCard(
            icon: Icons.phone_android_rounded,
            title: 'Mobile',
            text:
                'Aplicações mobile com foco em desempenho, usabilidade e experiência.',
          ),
          const SizedBox(height: 10),
          const _AreaCard(
            icon: Icons.dns_rounded,
            title: 'Back-end',
            text:
                'APIs, regras de negócio, autenticação e integração com bancos de dados.',
          ),
        ],
      ),
    );
  }
}

class _GitHubStatusCard extends StatelessWidget {
  final GitHubStatus? status;

  const _GitHubStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final current = status;

    if (current == null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .35),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: colors.surfaceContainerHigh,
              child: Icon(
                Icons.cloud_off_rounded,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GitHub indisponível',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Não foi possível carregar a atividade agora.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final dotColor = current.isRecentlyActive
        ? const Color(0xFF34A853)
        : colors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: .35),
        ),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: colors.primaryContainer,
                backgroundImage: current.avatarUrl.isNotEmpty
                    ? NetworkImage(current.avatarUrl)
                    : null,
                child: current.avatarUrl.isEmpty
                    ? Icon(Icons.code_rounded, color: colors.primary)
                    : null,
              ),
              Positioned(
                right: -1,
                bottom: 0,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        current.statusLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'GitHub',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  current.activityDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (current.publicRepos > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${current.publicRepos} repos',
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String? url;

  const _ProfileImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 128,
      height: 160,
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(44),
      ),
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: url != null && url!.isNotEmpty
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(context),
              )
            : _fallback(context),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: Text(
        'E',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton.filledTonal(
        onPressed: onTap,
        icon: Icon(icon),
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _AreaCard({
    required this.icon,
    required this.title,
    required this.text,
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
                Text(text, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Nenhum projeto publicado no momento.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
