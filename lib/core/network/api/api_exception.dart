abstract class ApiException implements Exception {
  final message;
  final prefix;

  ApiException(this.message, this.prefix);

  @override
  String toString() {
    return message != null ? '$prefix: $message' : prefix;
  }
}

class EmptyResultApiException extends ApiException {
  EmptyResultApiException() : super(null, 'No Data');
}

class BadRequestException extends ApiException {
  BadRequestException(message) : super(message, 'Invalid Request');
}

class UnauthorisedException extends ApiException {
  UnauthorisedException(message) : super(message, 'Unauthorised');
}

class FetchDataException extends ApiException {
  FetchDataException(message) : super(message, 'Error During Communication');
}

class NotFoundException extends ApiException {
  NotFoundException(message) : super(message, 'Not Found');
}

class ConnectionException extends ApiException {
  ConnectionException(message) : super(message, 'Connection Error');
}
