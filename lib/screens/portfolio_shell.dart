import 'package:flutter/material.dart';

import '../models/github_status.dart';
import '../models/portfolio_data.dart';
import '../services/github_service.dart';
import '../services/portfolio_api.dart';
import '../widgets/floating_portfolio_nav.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'experience_screen.dart';
import 'home_screen.dart';
import 'project_detail_screen.dart';
import 'projects_screen.dart';
import 'skills_screen.dart';

class PortfolioShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const PortfolioShell({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  final _api = PortfolioApi();
  final _github = GitHubService();

  int selectedIndex = 0;
  PortfolioData data = PortfolioData.fallback;
  GitHubStatus githubStatus = GitHubStatus.fallback;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        loading = true;
        error = null;
      });
    }

    String? portfolioError;

    try {
      final result = await _api.load();
      if (mounted) {
        setState(() => data = result);
      }
    } catch (e) {
      portfolioError = e.toString();
    }

    try {
      final status = await _github.loadStatus();
      if (mounted) {
        setState(() => githubStatus = status);
      }
    } catch (_) {
      // O status do GitHub é complementar e não bloqueia o portfólio.
    }

    if (!mounted) return;
    setState(() {
      loading = false;
      error = portfolioError;
    });
  }

  void _openProject(PortfolioProject project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(project: project),
      ),
    );
  }

  void _openPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _openMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Habilidades',
                    onTap: () {
                      Navigator.pop(context);
                      _openPage(const SkillsScreen());
                    },
                  ),
                  _MenuTile(
                    icon: Icons.timeline_rounded,
                    title: 'Experiência',
                    onTap: () {
                      Navigator.pop(context);
                      _openPage(const ExperienceScreen());
                    },
                  ),
                  _MenuTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contato',
                    onTap: () {
                      Navigator.pop(context);
                      _openPage(ContactScreen(settings: data.settings));
                    },
                  ),
                  _MenuTile(
                    icon: widget.themeMode == ThemeMode.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    title: widget.themeMode == ThemeMode.dark
                        ? 'Modo claro'
                        : 'Modo escuro',
                    onTap: () {
                      Navigator.pop(context);
                      widget.onThemeChanged(
                        widget.themeMode == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        data: data,
        githubStatus: githubStatus,
        onOpenAbout: () => setState(() => selectedIndex = 2),
        onOpenProjects: () => setState(() => selectedIndex = 1),
        onProjectTap: _openProject,
      ),
      ProjectsScreen(
        projects: data.projects,
        onProjectTap: _openProject,
      ),
      AboutScreen(settings: data.settings),
    ];

    return Scaffold(
      extendBody: true,
      appBar: selectedIndex == 0
          ? AppBar(
              title: loading
                  ? const Text('Atualizando...')
                  : error != null
                      ? const Text('Eric Y. Ikeda')
                      : null,
              actions: [
                if (error != null)
                  IconButton(
                    tooltip: 'Tentar carregar novamente',
                    onPressed: _load,
                    icon: const Icon(Icons.sync_problem_rounded),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton.filledTonal(
                    tooltip: 'Contato',
                    onPressed: () =>
                        _openPage(ContactScreen(settings: data.settings)),
                    icon: const Icon(Icons.mail_outline_rounded),
                  ),
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: KeyedSubtree(
              key: ValueKey(selectedIndex),
              child: pages[selectedIndex],
            ),
          ),
          if (loading)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (error != null)
            Positioned(
              left: 18,
              right: 18,
              bottom: 104,
              child: _OfflineBanner(onRetry: _load),
            ),
        ],
      ),
      bottomNavigationBar: FloatingPortfolioNav(
        selectedIndex: selectedIndex,
        onSelected: (index) => setState(() => selectedIndex = index),
        onMenuPressed: _openMenu,
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const _OfflineBanner({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.errorContainer,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: colors.onErrorContainer,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Usando dados salvos. Não foi possível acessar a API.',
                style: TextStyle(color: colors.onErrorContainer),
              ),
            ),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              color: colors.onErrorContainer,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
