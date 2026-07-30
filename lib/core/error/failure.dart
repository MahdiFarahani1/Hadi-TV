import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required String message, this.statusCode})
    : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure()
    : super('network_error_msg');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('timeout_error_msg');
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'unexpected_error_msg']);
}
