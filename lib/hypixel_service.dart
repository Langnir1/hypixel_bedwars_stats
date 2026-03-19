import 'package:http/http.dart' as http;
import 'package:hypixel_stat_tracker/data_parser.dart';
import 'package:hypixel_stat_tracker/url_builder.dart';
import 'package:hypixel_stat_tracker/bedwars_stats.dart';

class HypixelService {
  final UrlBuilder _urlBuilder = UrlBuilder();
  final DataParser _parser = DataParser();
  final http.Client _client;

  HypixelService({http.Client? client})
      : _client = client ?? http.Client();

  Future<BedwarsStats> getBedwarsStats(String username) async {
    final uri = _urlBuilder.buildUri(username);
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch player data');
    }

    return _parser.getBedwarsStats(response.body);
  }
}