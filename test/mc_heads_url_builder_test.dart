import 'package:flutter_test/flutter_test.dart';
import 'package:hypixel_stat_tracker/mc_heads_url_builder.dart';

void main() {
  test('MCHeadsUrlBuilder returns known username', () {
    final builder = McHeadsUrlBuilder();

    final url = builder.buildHead('Technoblade');

    expect(url, 'https://api.mcheads.org/head/Technoblade/256');
  });

  test('MCHeadsUrlBuilder returns a Url for a nonexistent username', (){
    final builder = McHeadsUrlBuilder();

    final url = builder.buildHead('DanthroLangnir');

    expect(url, 'https://api.mcheads.org/head/DanthroLangnir/256');
  });
}