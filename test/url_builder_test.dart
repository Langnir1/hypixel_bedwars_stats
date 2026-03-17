import 'package:hypixel_stat_tracker/url_builder.dart';
import 'package:test/test.dart';
import 'package:hypixel_stat_tracker/secrets.dart';

void main(){
  final builder = UrlBuilder();
  final url = builder.buildUri('Technoblade');
  test('Building the Uri scheme', (){
    expect(url.scheme, 'https');
  });

  test('Building the host of the uri', () {
    expect(url.host, 'api.hypixel.net');
  });

  test('Building the path of the uri', (){
    expect(url.path, '/v2/player');
  });

  test('builds the correct key parameter', () {
    expect(url.queryParameters['key'], api_key);
  });

  test('builds the correct username parameter', (){
    expect(url.queryParameters['name'], 'Technoblade');
  });
}