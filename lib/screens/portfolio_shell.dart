import 'package:flutter/material.dart';

import '../models/github_status.dart';
import '../models/portfolio_data.dart';
import '../services/github_service.dart';
import '../services/portfolio_api.dart';
import '../widgets/floating_portfolio_nav.dart';
import '../widgets/portfolio_logo.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'experience_screen.dart';
import 'services_screen.dart';
import 'github_screen.dart';
import 'education_screen.dart';
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
  final PageController _pageController = PageController();
  PortfolioData? data;
  GitHubStatus? githubStatus;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    final pageName = switch (page) {
      SkillsScreen() => 'Habilidades',
      ExperienceScreen() => 'Experiência',
      EducationScreen() => 'Formação',
      GitHubScreen() => 'GitHub',
      ServicesScreen() => 'Serviços',
      ContactScreen() => 'Contato',
      _ => 'Abrindo',
    };

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
      isScrollControlled: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        final items = <_PortfolioMenuItem>[
          _PortfolioMenuItem(
            icon: Icons.auto_awesome_rounded,
            title: 'Habilidades',
            subtitle: 'Stack e tecnologias',
            onTap: () {
              Navigator.pop(context);
              _openPage(const SkillsScreen());
            },
          ),
          _PortfolioMenuItem(
            icon: Icons.timeline_rounded,
            title: 'Experiência',
            subtitle: 'Minha jornada',
            onTap: () {
              Navigator.pop(context);
              _openPage(const ExperienceScreen());
            },
          ),
          _PortfolioMenuItem(
            icon: Icons.school_rounded,
            title: 'Formação',
            subtitle: 'Engenharia de Software',
            onTap: () {
              Navigator.pop(context);
              _openPage(const EducationScreen());
            },
          ),
          _PortfolioMenuItem(
            icon: Icons.code_rounded,
            title: 'GitHub',
            subtitle: 'Atividade pública',
            onTap: () {
              Navigator.pop(context);
              _openPage(GitHubScreen(status: githubStatus));
            },
          ),
          _PortfolioMenuItem(
            icon: Icons.design_services_rounded,
            title: 'Serviços',
            subtitle: 'Como posso ajudar',
            onTap: () {
              Navigator.pop(context);
              _openPage(
                ServicesScreen(settings: currentData.settings),
              );
            },
          ),
          _PortfolioMenuItem(
            icon: Icons.mail_outline_rounded,
            title: 'Contato',
            subtitle: 'Vamos conversar',
            onTap: () {
              Navigator.pop(context);
              _openPage(
                ContactScreen(settings: currentData.settings),
              );
            },
          ),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: colors.outlineVariant,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    Text(
                      'Explorar',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mais áreas do meu portfólio',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.28,
                      ),
                      itemBuilder: (context, index) {
                        return _PortfolioMenuCard(item: items[index]);
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      tileColor: colors.surfaceContainerLow,
                      leading: CircleAvatar(
                        backgroundColor: colors.primaryContainer,
                        foregroundColor: colors.primary,
                        child: Icon(
                          widget.themeMode == ThemeMode.dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                        ),
                      ),
                      title: Text(
                        widget.themeMode == ThemeMode.dark
                            ? 'Usar modo claro'
                            : 'Usar modo escuro',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
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
          ),
        );
      },
    );
  }

  void _selectTab(int index) {
    if (index == selectedIndex) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
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
      extendBodyBehindAppBar: false,
      appBar: selectedIndex == 0
          ? AppBar(
              titleSpacing: 18,
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PortfolioLogo(size: 38),
                  SizedBox(width: 10),
                  Text(
                    'Eric Y. Ikeda',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
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
        child: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            if (selectedIndex == index) return;
            setState(() => selectedIndex = index);
          },
          children: pages,
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
                width: 92,
                height: 92,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const PortfolioLogo(
                  size: 64,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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

class _PortfolioMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PortfolioMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _PortfolioMenuCard extends StatelessWidget {
  final _PortfolioMenuItem item;

  const _PortfolioMenuCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.primary,
                child: Icon(item.icon, size: 20),
              ),
              const Spacer(),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
