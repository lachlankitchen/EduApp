import 'dart:convert';
import 'package:edu_app/dart/degree/degree.dart';
import 'package:edu_app/dart/major/major.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http; // Import http package

class MockClient extends http.BaseClient {
  final Degree degree;
  List<Major>? majors;
  Major? major;

  MockClient({required this.degree, this.majors, this.major});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final responseHeaders = <String, String>{
      'Content-Type': 'application/json',
    };

    print(request.url.toString());

    // Mock the HTTP response based on the request URL
    if (request.url.toString() == 'http://localhost:1234/degrees') {
      const String mockDegrees = '{"degrees": ["Bachelor of Science", "Bachelor of Arts", "Bachelor of Engineering"]}';
      // Return a mock response for "/degrees" endpoint
      return http.StreamedResponse(
        Stream.value(utf8.encode(mockDegrees)),
        200,
        headers: responseHeaders,
      );
    } else if (request.url.toString() == 'http://localhost:1234/$degree/majors') {
      print("HERE");
      const String mockMajors = '{"degree": "Bachelor of Applied Science (BAppSc)", "majors": [ "Computer Science", "Oceanography", "Zoology" ]}';
      // Return a mock response for "/:degree/majors" endpoint
      return http.StreamedResponse(
        Stream.value(utf8.encode(mockMajors)),
        200,
        headers: responseHeaders,
      );
    } else if (request.url.toString().contains('/${degree.title}/')) {
      if (majors != null && majors!.isNotEmpty) {
        // Access the first element of majors if it's not null and not empty
        // You can access majors[0] or majors[1], etc., as needed
        final firstMajor = majors?[0];
        // Handle the response or return a mock response
        return http.StreamedResponse(
          Stream.value(utf8.encode('{"data": "Mock data for $firstMajor"}')),
          200,
          headers: responseHeaders,
        );
      } else {
        // Handle the case when majors is null or empty
        // Return a 404 or another suitable response
        return http.StreamedResponse(const Stream.empty(), 404);
      }
    }
    // } else if (request.method == 'POST' && request.url.toString().contains('/degree/major')) {
    //   // Handle a mock POST request to "/:degree/:major" endpoint
    //   // You can customize the response based on the request data
    //   final requestBody = await utf8.decodeStream(request.finalize().asStream());
    //   final requestData = jsonDecode(requestBody);
    //   final responseData = {'message': 'Received POST request with data: $requestData'};
    //   return http.StreamedResponse(
    //     Stream.value(utf8.encode(jsonEncode(responseData))),
    //     200,
    //     headers: responseHeaders,
    //   );
    // }

    // Return a 404 response for other requests
    return http.StreamedResponse(const Stream.empty(), 404);
  }
}
