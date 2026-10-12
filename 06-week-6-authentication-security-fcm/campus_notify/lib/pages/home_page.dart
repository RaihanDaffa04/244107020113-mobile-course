import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../messaging/push_service.dart';
import '../providers/auth_provider.dart';
import '../routes.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notify'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Pengumuman kampus'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(announcementRouteForId('1')),
            ),
            const SizedBox(height: 16),
            const Text(
              'Token FCM (debug)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              child: ValueListenableBuilder<String?>(
                valueListenable: currentFcmToken,
                builder: (context, token, child) => SelectableText(
                  maskFcmToken(token),
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: deviceTokenSyncStatus,
              builder: (context, status, child) => status == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(status),
                    ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: announcementsTopicSubscribed,
              builder: (context, subscribed, child) => SwitchListTile(
                title: const Text('Topik pengumuman kampus'),
                value: subscribed,
                onChanged: (value) async {
                  final service = PushService();
                  if (value) {
                    await service.subscribeToAnnouncements();
                  } else {
                    await service.unsubscribeFromAnnouncements();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
