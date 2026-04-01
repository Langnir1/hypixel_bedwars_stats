import 'package:flutter/material.dart';
import 'package:hypixel_stat_tracker/hypixel_service.dart';

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
  final HypixelService _service = HypixelService();

  String? _user1ResultText;
  String? _user2ResultText;
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
          'Final kills: ${stats.final_kills}\n'
          'Deaths: ${stats.deaths_bedwars}\n'
          'Final Deaths ${stats.final_deaths_bedwars}\n'
          'Beds Lost: ${stats.beds_lost_bedwars}\n'
          'Beds Broken: ${stats.beds_broken_bedwars}\n'
          'Wins: ${stats.wins_bedwars}\n'
          'Losses: ${stats.losses_bedwars}\n';

      setState(() {
        if (userNumber == 1) {
          _user1ResultText = resultText;
        } else {
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

  void _compareStats(){
    setState((){
      _showComparison = true;
    });
  }

  @override
  void dispose() {
    _username1Controller.dispose();
    _username2Controller.dispose();
    super.dispose();
  }

  Widget _buildStatsBox(String title, String? resultText){
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(resultText ?? 'No data'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Image.asset(
            'images/hypixelbedwars.png',
            width: 500,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
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
                      child: Text(
                        _selectedUser == 1
                            ?(_user1ResultText ?? 'No data')
                            :(_user2ResultText ?? 'No data'),
                      ),
                    ),
                  if(_showComparison)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsBox('Player 1', _user1ResultText),
                          const SizedBox(width: 12),
                          _buildStatsBox('Player 2', _user2ResultText),
                        ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}