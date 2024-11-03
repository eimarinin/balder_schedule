import 'package:flutter/material.dart';

import '../../utils/unanimated_page_route.dart';
import 'edit_screen.dart';

class EditNavigator extends StatelessWidget {
  const EditNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return UnanimatedPageRoute(
          builder: (context) => const EditScreen(),
        );
      },
    );
  }
}
