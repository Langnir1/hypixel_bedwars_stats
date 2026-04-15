import 'package:hypixel_stat_tracker/url_builder.dart';
import 'package:test/test.dart';

void main(){
  final builder = UrlBuilder(apiKey: 'test_key');
  final url = builder.buildUri('Technoblade');
  test('Building the Uri scheme', (){
    expect(url.scheme, 'https');
    expect(url.host, 'api.hypixel.net');
    expect(url.path, '/v2/player');
    expect(url.queryParameters['key'], 'test_key');
    expect(url.queryParameters['name'], 'Technoblade');
  });
}