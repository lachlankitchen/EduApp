import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http; // Import http package

// Define a custom mock class for HTTP responses
class MockClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Mock the HTTP response based on the request
    if (request.url.toString() == 'http://localhost:1234/degrees') {
      // Return a mock response
      return http.StreamedResponse(
        Stream.value(utf8.encode('{"degrees": ["Bachelor of Science", "Bachelor of Arts", "Bachelor of Engineering"]}')),
        200,
      );
    }
    return http.StreamedResponse(const Stream.empty(), 404);
  }
}