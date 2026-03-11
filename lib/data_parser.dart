import 'dart:convert';

class DataParser {
  String getBedwarsTotalKills(String content) {
    final decoded = jsonDecode(content);

    final result = decoded['player']['stats']['Bedwars']['kills_bedwars'];
    return result.toString();
  }
}
