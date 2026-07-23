class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'A server error occurred']);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'A cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Permission denied']);

  @override
  String toString() => 'PermissionException: $message';
}

class RecordingException implements Exception {
  final String message;
  const RecordingException([this.message = 'Recording failed']);

  @override
  String toString() => 'RecordingException: $message';
}
