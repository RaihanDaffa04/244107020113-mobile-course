import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final _local = FlutterLocalNotificationsPlugin();
String? pendingDeepLink;
final currentFcmToken = ValueNotifier<String?>(null);
final announcementsTopicSubscribed = ValueNotifier(false);
final deviceTokenSyncStatus = ValueNotifier<String?>(null);
void Function(String route)? _notificationRouteHandler;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void attachNotificationRouteHandler(void Function(String route) handler) {
  _notificationRouteHandler = handler;
  final route = pendingDeepLink;
  pendingDeepLink = null;
  if (route != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) => handler(route));
  }
}

void _openNotificationRoute(String? route) {
  if (route == null || route.isEmpty) return;
  final handler = _notificationRouteHandler;
  if (handler == null) {
    pendingDeepLink = route;
  } else {
    handler(route);
  }
}

class PushService {
  bool _initialized = false;

  Future<bool> requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const channel = AndroidNotificationChannel(
      'pengumuman',
      'Pengumuman Kampus',
      description: 'Notifikasi pengumuman kampus',
      importance: Importance.high,
    );

    await _local.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        _openNotificationRoute(response.payload);
      },
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'pengumuman',
      'Pengumuman Kampus',
      channelDescription: 'Notifikasi pengumuman kampus',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _local.show(
      id: message.messageId?.hashCode ?? message.hashCode,
      title: message.notification?.title ?? 'Pengumuman',
      body: message.notification?.body ?? '',
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: routeFromMessage(message.data),
    );
  }

  Future<void> _listenForMessages() async {
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _openNotificationRoute(routeFromMessage(message.data));
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _openNotificationRoute(routeFromMessage(initialMessage.data));
    }
  }

  Future<void> initFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      currentFcmToken.value = token;
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      currentFcmToken.value = newToken;
      deviceTokenSyncStatus.value = 'Token berubah; menunggu sinkronisasi.';
    });

    await subscribeToAnnouncements();
  }

  Future<void> subscribeToAnnouncements() async {
    await FirebaseMessaging.instance.subscribeToTopic('pengumuman-kampus');
    announcementsTopicSubscribed.value = true;
  }

  Future<void> unsubscribeFromAnnouncements() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('pengumuman-kampus');
    announcementsTopicSubscribed.value = false;
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await requestNotificationPermission();
    await initLocalNotifications();
    await _listenForMessages();
    await initFcmToken();
  }
}

String maskFcmToken(String? token) {
  if (token == null) {
    return 'loading...';
  }
  if (token.length <= 12) {
    return '${token.substring(0, token.length)}...';
  }
  return '${token.substring(0, 12)}...';
}
