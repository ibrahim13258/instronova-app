/// Stub ApiClient to satisfy imports.
/// TODO: Replace with real API client implementation.
class ApiClient {
  Future<dynamic> get(String url) async {
    throw UnimplementedError('ApiClient.get not implemented. URL: $url');
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    throw UnimplementedError('ApiClient.post not implemented. URL: $url');
  }
}