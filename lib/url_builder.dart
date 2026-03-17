import 'secrets.dart';

class UrlBuilder {
  Uri buildUri(String username) {
    return Uri.parse(
      'https://api.hypixel.net/v2/player?',
      'key=${Uri.encodeComponent(apiKey)}',
      '&name=${Uri.encodeComponent(username)}',
    );
  }
}
