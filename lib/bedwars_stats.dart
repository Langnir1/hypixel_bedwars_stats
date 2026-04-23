class BedwarsStats {
  final bool hasBedwarsStats;
  final int kills; /// This is total kills of all types of kills.
  final int gamesPlayed;
  final int finalKills;
  final int deaths_bedwars; /// This is the total deaths for all types of deaths.
  final int final_deaths_bedwars;
  final int beds_lost_bedwars;
  final int beds_broken_bedwars;
  final int wins_bedwars; /// Overall wins for every type of game mode.
  final int losses_bedwars; /// Overall losses for every type of game mode

  BedwarsStats({
    required this.hasBedwarsStats,
    required this.kills,
    required this.gamesPlayed,
    required this.finalKills,
    required this.deaths_bedwars,
    required this.final_deaths_bedwars,
    required this.beds_lost_bedwars,
    required this.beds_broken_bedwars,
    required this.wins_bedwars,
    required this.losses_bedwars,
  });

  double get winLossRatio =>
      losses_bedwars == 0 ? wins_bedwars.toDouble() : wins_bedwars / losses_bedwars;

  double get killDeathRatio =>
      deaths_bedwars == 0 ? kills.toDouble() : kills / deaths_bedwars;

  double get finalKillDeathRatio =>
      final_deaths_bedwars == 0 ? finalKills.toDouble() : finalKills / final_deaths_bedwars;
}