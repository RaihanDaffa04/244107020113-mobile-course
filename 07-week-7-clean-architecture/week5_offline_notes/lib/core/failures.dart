import 'dart:io';

import 'package:dio/dio.dart';

sealed class Failure implements Exception {
  const Failure(this.message);
  final String message;
}

class LocalFailure extends Failure {
  const LocalFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

Failure mapExceptionToFailure(Object error) {
  if (error is Failure) return error;

  final normalized = error.toString().toLowerCase();

  if (error is DioException ||
      error is HttpException ||
      error is SocketException ||
      normalized.contains('network') ||
      normalized.contains('socket') ||
      normalized.contains('http')) {
    return const NetworkFailure(
      'Koneksi internet tidak stabil. Silakan coba lagi.',
    );
  }

  if (normalized.contains('db') ||
      normalized.contains('database') ||
      normalized.contains('lock') ||
      normalized.contains('sqlite')) {
    return const LocalFailure(
      'Database sedang sibuk. Silakan coba lagi.',
    );
  }

  return const LocalFailure('Terjadi masalah. Silakan coba lagi.');
}

String toUserMessage(Object error) => mapExceptionToFailure(error).message;