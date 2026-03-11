import 'dart:io';

import 'package:hypixel_stat_tracker/data_parser.dart';
import 'package:test/test.dart';

void main() {
  test("Getting Bedwars kills", () async {
    final content = await File('test/technoblade.json').readAsString();
    DataParser parser = DataParser();
    final bedwarsKills = parser.getBedwarsTotalKills(content);
    expect(bedwarsKills, "7707");
  });
}
