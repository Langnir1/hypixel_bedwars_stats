import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:hypixel_stat_tracker/hypixel_service.dart';

void main(){
  test('Exception when the client throws SocketException',
      () async{
    final mockClient = MockClient((request) async{
      throw const SocketException('No internet');
    });
    final service = HypixelService(apiKey: 'test_key', client: mockClient);
    await expectLater(
      service.getBedwarsStats('technoblade'),
      throwsA(isA<Exception>()),
    );
  });

  test('returns successful request', () async{
    final content = await File('test/technoblade.json').readAsString();
    final mockClient = MockClient((request) async {
      return http.Response(content, 200);
    });
    final service = HypixelService(apiKey: 'test_key', client: mockClient);
    final result = await service.getBedwarsStats('technoblade');
    expect(result, 7707);
  });
}