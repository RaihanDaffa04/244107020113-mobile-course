import 'package:dio/dio.dart';

String apiErrorMessage(DioException exception) {
  if (exception.response?.statusCode == 401) {
    return 'Sesi berakhir. Silakan masuk kembali.';
  }

  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return 'Server terlalu lama merespons. Coba lagi.';
    case DioExceptionType.connectionError:
      return 'Tidak dapat terhubung. Periksa koneksi internet Anda.';
    case DioExceptionType.badResponse:
      final statusCode = exception.response?.statusCode;
      if (statusCode == 403) return 'Anda tidak memiliki akses.';
      if (statusCode == 404) return 'Data atau layanan tidak ditemukan.';
      if (statusCode != null && statusCode >= 500) {
        return 'Server sedang bermasalah. Coba lagi nanti.';
      }
      return 'Permintaan tidak dapat diproses.';
    case DioExceptionType.cancel:
      return 'Permintaan dibatalkan.';
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return 'Terjadi kesalahan jaringan. Coba lagi.';
  }
}

String friendlyErrorMessage(Object error) {
  if (error is DioException) return apiErrorMessage(error);
  return error.toString().replaceFirst('Exception: ', '');
}