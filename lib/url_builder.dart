class UrlBuilder {
  final String apiKey;

  UrlBuilder({required this.apiKey});

  Uri buildUri(String username) {
    return Uri.https(
      'api.hypixel.net',
      '/v2/player',
      {
        'key': apiKey,
        'name': username,
      }
    );
  }
}
