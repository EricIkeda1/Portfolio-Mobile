import 'package:flutter/material.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
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
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
            );
          },
        );
}
