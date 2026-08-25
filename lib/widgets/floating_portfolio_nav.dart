import 'package:flutter/material.dart';

class FloatingPortfolioNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onMenuPressed;

  const FloatingPortfolioNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final items = [
      (Icons.home_outlined, Icons.home_rounded, 'Início'),
      (Icons.work_outline_rounded, Icons.work_rounded, 'Projetos'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Sobre'),
    ];

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 68,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: .4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: .12),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final selected = selectedIndex == index;
                  final item = items[index];

                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () => onSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          color: selected
                              ? colors.primaryContainer.withValues(alpha: .72)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: selected ? 1.08 : 1,
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutBack,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                ),
                                child: Icon(
                                  selected ? item.$2 : item.$1,
                                  key: ValueKey(selected),
                                  color: selected
                                      ? colors.primary
                                      : colors.onSurfaceVariant,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.$3,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? colors.primary
                                    : colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 62,
            height: 62,
            child: FloatingActionButton(
              heroTag: 'main-menu',
              onPressed: onMenuPressed,
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              elevation: 5,
              child: const Icon(Icons.more_vert_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
