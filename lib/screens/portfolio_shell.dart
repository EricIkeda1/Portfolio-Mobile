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
  final _githubService = GitHubService();

  int selectedIndex = 0;
  PortfolioData? data;
  GitHubStatus? githubStatus;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final portfolioFuture = _api.load();
      final githubFuture = _githubService.loadStatus();

      final portfolioResult = await portfolioFuture;

      GitHubStatus? githubResult;
      try {
        githubResult = await githubFuture;
      } catch (_) {
        githubResult = null;
      }

      if (!mounted) return;

      setState(() {
        data = portfolioResult;
        githubStatus = githubResult;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        data = null;
        loading = false;
        error = e.toString();
      });
    }
  }

  void _openProject(PortfolioProject project) {
    Navigator.of(context).push(
      _expressiveRoute(
        ProjectDetailScreen(project: project),
      ),
    );
  }

  void _openPage(Widget page) {
    Navigator.of(context).push(_expressiveRoute(page));
  }

  PageRouteBuilder<void> _expressiveRoute(Widget page) {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final fade = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(curved);

        final slide = Tween<Offset>(
          begin: const Offset(0, .035),
          end: Offset.zero,
        ).animate(curved);

        final scale = Tween<double>(
          begin: .985,
          end: 1,
        ).animate(curved);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }

  void _openMenu() {
    final currentData = data;
    if (currentData == null) return;

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
                      _openPage(
                        ContactScreen(settings: currentData.settings),
                      );
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

  void _selectTab(int index) {
    if (index == selectedIndex) return;
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: const _LoadingScreen(),
      );
    }

    if (error != null || data == null) {
      return Scaffold(
        body: _ApiErrorScreen(
          onRetry: _load,
        ),
      );
    }

    final currentData = data!;

    final pages = [
      HomeScreen(
        data: currentData,
        githubStatus: githubStatus,
        onOpenAbout: () => _selectTab(2),
        onOpenProjects: () => _selectTab(1),
        onProjectTap: _openProject,
      ),
      ProjectsScreen(
        projects: currentData.projects,
        onProjectTap: _openProject,
      ),
      AboutScreen(settings: currentData.settings),
    ];

    return Scaffold(
      extendBody: true,
      appBar: selectedIndex == 0
          ? AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton.filledTonal(
                    tooltip: 'Contato',
                    onPressed: () => _openPage(
                      ContactScreen(settings: currentData.settings),
                    ),
                    icon: const Icon(Icons.mail_outline_rounded),
                  ),
                ),
              ],
            )
          : null,
      body: SafeArea(
        top: selectedIndex != 0,
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final key = child.key;
          final newIndex = key is ValueKey<int> ? key.value : selectedIndex;
          final direction = newIndex >= selectedIndex ? 1.0 : -1.0;

          final slide = Tween<Offset>(
            begin: Offset(.035 * direction, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slide,
              child: child,
            ),
          );
        },
          child: KeyedSubtree(
            key: ValueKey<int>(selectedIndex),
            child: pages[selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: FloatingPortfolioNav(
        selectedIndex: selectedIndex,
        onSelected: _selectTab,
        onMenuPressed: _openMenu,
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  Icons.cloud_sync_rounded,
                  size: 38,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Carregando portfólio',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Buscando os dados mais recentes.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  minHeight: 5,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApiErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const _ApiErrorScreen({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      Icons.cloud_off_rounded,
                      size: 38,
                      color: colors.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Não foi possível carregar o portfólio',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'O aplicativo não conseguiu acessar a API. Nenhum dado antigo foi exibido.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onRetry,
                      child: const Text(
                        'Tentar novamente',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
