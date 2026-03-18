import 'dart:convert';

class DataParser {
  int getBedwarsTotalKills(String content) {
    final decoded = jsonDecode(content);

    final player = decoded['player'];
    if (player == null) {
      throw Exception('Player not found on Hypixel');
    }

    final stats = player['stats'];
    final bedwars = stats?['Bedwars'];

    if (bedwars == null) {
      throw Exception('No Bedwars stats found');
    }

    final kills = bedwars['kills_bedwars'];

    if (kills == null) {
      return 0;
    }

    return kills as int;
  }
}
