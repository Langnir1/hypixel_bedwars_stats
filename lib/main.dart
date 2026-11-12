import 'package:flutter/material.dart';
import 'package:hypixel_stat_tracker/hypixel_service.dart';
import 'package:hypixel_stat_tracker/secrets.dart';
import 'package:hypixel_stat_tracker/bedwars_stats.dart';
import 'package:hypixel_stat_tracker/mc_heads_url_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hypixel Comparator',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _username1Controller = TextEditingController();
  final TextEditingController _username2Controller = TextEditingController();
  final HypixelService _service = HypixelService(apiKey: apiKey);
  final McHeadsUrlBuilder _mcHeadsUrlBuilder = McHeadsUrlBuilder();

  String? _user1ResultText;
  String? _user2ResultText;
  BedwarsStats? _user1Stats;
  BedwarsStats? _user2Stats;
  bool _showComparison = false;
  int _selectedUser = 1;

  Future<void> _seeStats(int userNumber) async {
    final username = userNumber == 1
        ? _username1Controller.text.trim()
        : _username2Controller.text.trim();

    setState((){
      _showComparison = false;
      _selectedUser = userNumber;
    });

    if (username.isEmpty) {
      setState(() {
        if(userNumber == 1){
          _user1ResultText = 'Please enter a username.';
        } else{
          _user2ResultText = 'Please enter a username.';
        }
      });
      return;
    }

    try {
      final stats = await _service.getBedwarsStats(username);

      final resultText = !stats.hasBedwarsStats
        ? 'No Bedwars Stats.'
        :'Games Played: ${stats.gamesPlayed}\n'
          'Kills: ${stats.kills}\n'
          'Final kills: ${stats.finalKills}\n'
          'Deaths: ${stats.deaths_bedwars}\n'
          'Final Deaths ${stats.final_deaths_bedwars}\n'
          'Kill/Death Ratio: ${stats.killDeathRatio.toStringAsFixed(2)}\n'
          'Final Kills/Final Deaths: ${stats.finalKillDeathRatio.toStringAsFixed(2)}\n'
          'Beds Lost: ${stats.beds_lost_bedwars}\n'
          'Beds Broken: ${stats.beds_broken_bedwars}\n'
          'Wins: ${stats.wins_bedwars}\n'
          'Losses: ${stats.losses_bedwars}\n'
          'Win/Loss Ratio: ${stats.winLossRatio.toStringAsFixed(2)}\n';

      setState(() {
        if (userNumber == 1) {
          _user1Stats = stats;
          _user1ResultText = resultText;
        } else {
          _user2Stats = stats;
          _user2ResultText = resultText;
        }
      });
    } catch (e){
      setState(() {
        if(userNumber == 1){
          _user1ResultText = e.toString().replaceFirst('Exception:', '');
        } else{
          _user2ResultText = e.toString().replaceFirst('Exception: ', '');
        }
      });
    }
  }

  ///Only lets the user compare both stats after both stats have loaded.
  void _compareStats(){
    if (_user1Stats == null || _user2Stats == null){
      return;
    }
    setState((){
      _showComparison = true;
    });
  }

  Color _getHigherStatColor(num userValue, num otherValue){
    if(userValue > otherValue){
      return Colors.green;
    }
    else if(userValue == otherValue){
      return Colors.blue;
    }
    return Colors.black;
  }

  Widget _buildStatRow(String label, String value, Color color){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:2),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontWeight: color == Colors.green ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPlayerHead(String username) {
    final imageUrl = _mcHeadsUrlBuilder.buildHead(username);

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        border:  Border.all(color: Colors.black),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        ///Shows a general flutter person icon if the player head doesn't load.
        errorBuilder: (context, error, stackTrace){
          return const Center(
          child: Icon(Icons.person, size: 40),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _username1Controller.dispose();
    _username2Controller.dispose();
    super.dispose();
  }

  Widget _buildStatsBox(
      String title,
      String username,
      BedwarsStats? currentStats,
      BedwarsStats? otherStats,
      ) {
    if (currentStats == null) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text('No data'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildPlayerHead(username),
                    ],
                  ),
              ),
            ],
          )
        ),
      );
    }

    final other = otherStats;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildStatRow(
                  'Games Played',
                  currentStats.gamesPlayed.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.gamesPlayed, other.gamesPlayed),
                ),
                _buildStatRow('Kills',
                  currentStats.kills.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.kills, other.kills),
                ),
                _buildStatRow('Final Kills',
                  currentStats.finalKills.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.finalKills, other.finalKills),
                ),
                _buildStatRow('Deaths', currentStats.deaths_bedwars.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.deaths_bedwars, other.deaths_bedwars),
                ),
                _buildStatRow('Final Deaths',
                  currentStats.final_deaths_bedwars.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.final_deaths_bedwars, other.final_deaths_bedwars),
                ),
                _buildStatRow('Kill/Death Ratio',
                  currentStats.killDeathRatio.toStringAsFixed(2),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.killDeathRatio, other.killDeathRatio),
                ),
                _buildStatRow('Final Kill/Final Death Ratio',
                  currentStats.finalKillDeathRatio.toStringAsFixed(2),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.finalKillDeathRatio, other.finalKillDeathRatio),
                ),
                _buildStatRow('Beds Lost',
                  currentStats.beds_lost_bedwars.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.beds_lost_bedwars, other.beds_lost_bedwars),
                ),
                _buildStatRow('Beds broken',
                  currentStats.beds_broken_bedwars.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.beds_broken_bedwars, other.beds_broken_bedwars),
                ),
                _buildStatRow('Wins',
                  currentStats.wins_bedwars.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.wins_bedwars, other.wins_bedwars),
                ),
                _buildStatRow('Losses',
                  currentStats.losses_bedwars.toString(),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.losses_bedwars, other.losses_bedwars),
                ),
                _buildStatRow('Win/Loss Ratio',
                  currentStats.winLossRatio.toStringAsFixed(2),
                  other == null
                      ? Colors.black
                      : _getHigherStatColor(currentStats.winLossRatio, other.winLossRatio),
                ),
              ],
            ),
            ),
            const SizedBox(width: 12),
            _buildPlayerHead(username),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child:Column(
        children: <Widget>[
          Image.asset(
            'images/hypixelbedwars.png',
            width: 500,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),

          Image.asset(
            'images/playerstat.png',
                width: 200,
                fit: BoxFit.contain,
          ),
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _username1Controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a Minecraft username',
                        hintStyle: TextStyle(
                          color: Color(0xFF9E9E9E),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _seeStats(1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _username2Controller,
                      decoration: InputDecoration(
                        hintText: 'Enter second Minecraft username',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _seeStats(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _seeStats(1),
                    child: const Text('Stats player 1'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () => _seeStats(2),
                      child: const Text('Stats Player 2'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _compareStats,
                    child: const Text('Compare'),
                  ),
                  const SizedBox(height: 20),

                  if(!_showComparison)
                    Container(
                      width: 220,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(
                            _selectedUser == 1
                                ?(_user1ResultText ?? 'No data')
                                :(_user2ResultText ?? 'No data'),
                          ),
                          ),
                          const SizedBox(width: 12),
                          _buildPlayerHead(
                              _selectedUser == 1
                                  ? _username1Controller.text.trim()
                                  : _username2Controller.text.trim(),
                          ),
                        ],
                      ),
                    ),
                  if(_showComparison)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsBox('Player 1 - ${_username1Controller.text.trim()}',
                              _username1Controller.text.trim(),
                              _user1Stats,
                              _user2Stats),

                          const SizedBox(width: 12),
                          _buildStatsBox('Player 2 - ${_username2Controller.text.trim()}',
                              _username2Controller.text.trim(),
                              _user2Stats,
                              _user1Stats),
                        ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}