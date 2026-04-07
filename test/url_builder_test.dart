import 'package:hypixel_stat_tracker/url_builder.dart';
import 'package:test/test.dart';
import 'package:hypixel_stat_tracker/secrets.dart';

void main(){
  final builder = UrlBuilder();
  final url = builder.buildUri('Technoblade');
  test('Building the Uri scheme', (){
    expect(url.scheme, 'https');
    expect(url.host, 'api.hypixel.net');
    expect(url.path, '/v2/player');
    expect(url.queryParameters['key'], apiKey);
    expect(url.queryParameters['name'], 'Technoblade');
  });
}