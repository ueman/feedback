import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:feedback_gitlab/feedback_gitlab.dart';
import 'package:http/http.dart';

void main() {
  test('uploads', () async {
    final mockClient = MockClient();
    var onFeedback = uploadToGitLab(
      projectId: '123',
      apiToken: '123',
      gitlabUrl: 'example.org',
      client: mockClient,
    );

    onFeedback(UserFeedback(
      screenshot: Uint8List.fromList([]),
      text: 'foo bar',
      extra: {'foo': 'bar'},
    ));

    final result = await mockClient.completer.future;
    expect(result, true);
  });
}

class MockClient extends BaseClient {
  int calls = 0;
  Completer<bool> completer = Completer<bool>();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    calls++;
    if (request is MultipartRequest) {
      return toStreamedResponse(
        request,
        onMultipartRequest(request),
      );
    }

    if (request is Request) {
      completer.complete(true);
      return toStreamedResponse(
        request,
        onRequest(request),
      );
    }

    fail('This should not be reached');
  }

  Response onRequest(Request request) {
    expect(request.method, 'POST');
    expect(
      request.url,
      Uri.parse(
        'https://example.org/api/v4/projects/123/issues?title=foo+bar&description=foo+bar%0A%0A%7Bfoo%3A+bar%7D',
      ),
    );
    expect(request.headers, {'PRIVATE-TOKEN': '123'});
    return Response('', 200);
  }

  Response onMultipartRequest(MultipartRequest request) {
    expect(request.method, 'POST');
    expect(request.url,
        Uri.parse('https://example.org/api/v4/projects/123/uploads'));
    expect(request.headers, {'PRIVATE-TOKEN': '123'});
    expect(request.fields.length, 0);
    expect(request.files.length, 1);

    var file = request.files.first;

    expect(file.field, 'file');
    expect(file.contentType.mimeType, 'application/octet-stream');

    return Response(jsonEncode({'markdown': ''}), 200);
  }

  StreamedResponse toStreamedResponse(BaseRequest request, Response response) {
    return StreamedResponse(
      ByteStream.fromBytes(response.bodyBytes),
      response.statusCode,
      contentLength: response.contentLength,
      request: request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
