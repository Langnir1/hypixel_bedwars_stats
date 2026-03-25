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
      return BedwarsStats(hasBedwarsStats: false, kills: 0, gamesPlayed: 0);
    }

    return BedwarsStats(
      kills: bedwars['kills_bedwars'] ?? 0,
      gamesPlayed: bedwars['games_played_bedwars_1'] ?? 0,
      hasBedwarsStats: true,
    );
  }
}
