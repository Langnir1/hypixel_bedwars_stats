import 'secrets.dart';

class UrlBuilder {
  Uri buildUri(String username) {
    return Uri.https(
      'api.hypixel.net',
      '/v2/player',
      {
        'key': api_key,
        'name': username,
      }
    );
  }
}
