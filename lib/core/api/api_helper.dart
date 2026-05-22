import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

/// API Helper class - centralizes HTTP operations with proper error handling
class ApiHelper {
  final http.Client _client;
  final Duration timeout;

  ApiHelper(this._client, {this.timeout = const Duration(seconds: 30)});

  /// GET request
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .get(
            Uri.parse(url),
            headers: _buildHeaders(headers),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException catch (e) {
      throw NetworkException(originalError: e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException(originalError: e);
    }
  }

  /// GET request returning List
  Future<List<dynamic>> getList(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .get(
            Uri.parse(url),
            headers: _buildHeaders(headers),
          )
          .timeout(timeout);

      return _handleListResponse(response);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException(originalError: e);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException(originalError: e);
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .put(
            Uri.parse(url),
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException(originalError: e);
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .delete(
            Uri.parse(url),
            headers: _buildHeaders(headers),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException(originalError: e);
    }
  }

  /// POST request with multipart (for file uploads)
  Future<Map<String, dynamic>> postMultipart(
    String url, {
    required Map<String, String> fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      } else {
        request.headers['Content-Type'] = 'application/json';
      }

      // Add fields
      request.fields.addAll(fields);

      // Add files
      if (files != null) {
        for (final entry in files.entries) {
          request.files.add(await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          ));
        }
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException(originalError: e);
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);

    // Handle empty response
    if (body.isEmpty) {
      return {'statusCode': response.statusCode};
    }

    try {
      final decoded = jsonDecode(body);
      
      if (decoded is Map<String, dynamic>) {
        // Add status code to response for convenience
        return {...decoded, '_statusCode': response.statusCode};
      }
      
      return {'data': decoded, '_statusCode': response.statusCode};
    } catch (e) {
      throw ParseException(originalError: e);
    }
  }

  List<dynamic> _handleListResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);

    if (body.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(body);
      
      if (decoded is List) {
        return decoded;
      }
      
      throw const ParseException(message: 'Expected list response');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ParseException(originalError: e);
    }
  }

  /// Add authorization token to headers
  Map<String, String> withAuth(String token, {Map<String, String>? headers}) {
    final newHeaders = _buildHeaders(headers);
    newHeaders['Authorization'] = 'Bearer $token';
    return newHeaders;
  }
}
