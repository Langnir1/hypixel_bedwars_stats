import 'dart:convert';
import 'package:hypixel_stat_tracker/bedwars_stats.dart';

class DataParser {
  BedwarsStats getBedwarsStats(String content) {
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

    //final kills = bedwars['kills_bedwars'];
    //final gamesPlayed = bedwars['games_played_bedwars_1'];

    return BedwarsStats(
      kills: bedwars['kills_bedwars'] ?? 0,
      gamesPlayed: bedwars['games_played_bedwars_1'] ?? 0,
    );
  }
}
