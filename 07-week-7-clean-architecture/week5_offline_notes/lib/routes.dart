import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'features/notes/presentation/pages/notes_page.dart';

abstract final class RoutePaths {
  static const notes = '/notes';
}

final GoRouter notesRouter = GoRouter(
  initialLocation: RoutePaths.notes,
  routes: [
    GoRoute(
      path: RoutePaths.notes,
      builder: (BuildContext context, GoRouterState state) =>
          const NotesPage(),
    ),
  ],
);