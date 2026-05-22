import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final int statusCode;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isError => statusCode >= 400;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      errors: json['errors'],
    );
  }

  @override
  List<Object?> get props => [statusCode, message, data, errors];
}

/// Generic list response
class ApiListResponse<T> extends Equatable {
  final int statusCode;
  final String message;
  final List<T>? data;

  const ApiListResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiListResponse(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  @override
  List<Object?> get props => [statusCode, message, data];
}
