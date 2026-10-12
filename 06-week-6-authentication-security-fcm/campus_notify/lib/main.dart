import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'messaging/push_service.dart';
import 'pages/announcement_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: _RouterApp());
  }
}

class _RouterApp extends ConsumerStatefulWidget {
  const _RouterApp();

  @override
  ConsumerState<_RouterApp> createState() => _RouterAppState();
}

class _RouterAppState extends ConsumerState<_RouterApp> {
  late final ValueNotifier<int> _routerRefresh;
  late final ProviderSubscription<AsyncValue<bool>> _authSubscription;
  late final GoRouter _router;
  String? _lastRegisteredFcmToken;

  @override
  void initState() {
    super.initState();
    _routerRefresh = ValueNotifier(0);
    _authSubscription = ref.listenManual(authStateProvider, (previous, next) {
      _routerRefresh.value++;
      if (next.value == true) _syncFcmToken();
    });
    currentFcmToken.addListener(_syncFcmToken);
    _router = GoRouter(
      navigatorKey: navigatorKey,
      refreshListenable: _routerRefresh,
      redirect: (context, state) {
        final authState = ref.read(authStateProvider);
        if (authState.isLoading) return null;

        final loggedIn = authState.value ?? false;
        final goingToLogin = state.matchedLocation == loginRoute;
        if (!loggedIn && !goingToLogin) {
          return Uri(
            path: loginRoute,
            queryParameters: {'from': state.uri.toString()},
          ).toString();
        }
        if (loggedIn && goingToLogin) {
          return state.uri.queryParameters['from'] ?? homeRoute;
        }
        return null;
      },
      routes: [
        GoRoute(path: loginRoute, builder: (context, state) => const LoginPage()),
        GoRoute(path: homeRoute, builder: (context, state) => const HomePage()),
        GoRoute(
          path: announcementRoutePattern,
          builder: (context, state) =>
              AnnouncementPage(id: state.pathParameters['id'] ?? ''),
        ),
      ],
    );
    attachNotificationRouteHandler(_router.go);
  }

  Future<void> _syncFcmToken() async {
    final token = currentFcmToken.value;
    if (token == null || token == _lastRegisteredFcmToken) return;
    if (ref.read(authStateProvider).value != true) return;

    deviceTokenSyncStatus.value = 'Mengirim token ke backend...';
    try {
      await ref.read(deviceTokenRepositoryProvider).registerToken(token);
      _lastRegisteredFcmToken = token;
      deviceTokenSyncStatus.value = 'Token berhasil disinkronkan ke backend.';
    } catch (error) {
      deviceTokenSyncStatus.value = error is StateError
          ? 'Backend belum dikonfigurasi (API_BASE_URL).'
          : 'Gagal menyinkronkan token ke backend.';
    }
  }

  @override
  void dispose() {
    currentFcmToken.removeListener(_syncFcmToken);
    _authSubscription.close();
    _router.dispose();
    _routerRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Campus Notify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      routerConfig: _router,
    );
  }
}
