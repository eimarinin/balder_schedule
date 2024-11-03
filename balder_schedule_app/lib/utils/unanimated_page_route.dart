// lib/utils/unanimated_page_route.dart

import 'package:flutter/material.dart';

class UnanimatedPageRoute<T> extends MaterialPageRoute<T> {
  UnanimatedPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  Duration get transitionDuration =>
      Duration.zero; // Убираем задержку при переходе
  @override
  Duration get reverseTransitionDuration =>
      Duration.zero; // Убираем задержку при возврате

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // Возвращаем дочерний элемент без анимации
  }
}
