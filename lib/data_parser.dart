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
      return BedwarsStats(
          hasBedwarsStats: false,
          kills: 0,
          gamesPlayed: 0,
          finalKills: 0,
          deaths_bedwars: 0,
          final_deaths_bedwars: 0,
          beds_lost_bedwars: 0,
          beds_broken_bedwars: 0,
          wins_bedwars: 0,
          losses_bedwars: 0,
      );
    }

    return BedwarsStats(
      kills: bedwars['kills_bedwars'] ?? 0,
      gamesPlayed: bedwars['games_played_bedwars_1'] ?? 0,
      finalKills: bedwars['final_kills_bedwars'] ?? 0,
      deaths_bedwars: bedwars['deaths_bedwars'] ?? 0,
      final_deaths_bedwars: bedwars['final_deaths_bedwars'] ?? 0,
      beds_lost_bedwars: bedwars['beds_lost_bedwars'] ?? 0,
      beds_broken_bedwars: bedwars['beds_broken_bedwars'] ?? 0,
      wins_bedwars: bedwars['wins_bedwars'] ?? 0,
      losses_bedwars: bedwars['losses_bedwars'] ?? 0,
      hasBedwarsStats: true,
    );
  }
}
