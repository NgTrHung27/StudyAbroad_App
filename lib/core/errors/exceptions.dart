class ServerException implements Exception {
  final String? message;
  final int? statusCode;
  
  const ServerException({this.message, this.statusCode});
  
  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String? message;
  
  const NetworkException({this.message});
  
  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String? message;
  
  const CacheException({this.message});
  
  @override
  String toString() => 'CacheException: $message';
}

class UnauthorizedException implements Exception {
  final String? message;
  
  const UnauthorizedException({this.message});
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ParseException implements Exception {
  final String? message;
  
  const ParseException({this.message});
  
  @override
  String toString() => 'ParseException: $message';
}
