abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A cache error occurred']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Microphone permission denied']);
}

class RecordingFailure extends Failure {
  const RecordingFailure([super.message = 'Failed to start or stop recording']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}
