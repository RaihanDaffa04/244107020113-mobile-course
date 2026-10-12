import 'dart:io';

import 'package:dio/dio.dart';

import 'api_client.dart';

class DeviceTokenRepository {
  const DeviceTokenRepository(this._dio);

  final Dio _dio;

  Future<void> registerToken(String token) async {
    if (apiBaseUrl.isEmpty) {
      throw StateError('API_BASE_URL belum dikonfigurasi.');
    }

    await _dio.post<void>(
      '/devices',
      data: {
        'fcm_token': token,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      },
    );
  }
}
