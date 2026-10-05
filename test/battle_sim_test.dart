import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_arena/battle/core/battle_sim.dart';

EntityState mk(String id, {int hp = 100, int atk = 10, int def = 2, double crit = 0.0, int cd = 60}) =>
    EntityState(id: id, maxHp: hp, attack: atk, defense: def, speed: 1, range: 1, cooldown: cd, critChance: crit);

void main() {
  test('same seed reproduces same event log', () {
    final s1 = BattleSim(a: mk('a'), b: mk('b'), seed: 7);
    final s2 = BattleSim(a: mk('a'), b: mk('b'), seed: 7);
    while (!s1.finished) { s1.step(); s2.step(); }
    expect(s1.events.map((e) => e.toString()).join('|'), s2.events.map((e) => e.toString()).join('|'));
    expect(s1.winnerId, s2.winnerId);
  });

  test('battle finishes within time cap', () {
    final sim = BattleSim(a: mk('a', atk: 1), b: mk('b', atk: 1), seed: 1);
    int guard = 0;
    while (!sim.finished && guard++ < 60 * 60) sim.step();
    expect(sim.finished, isTrue);
  });

  test('damage respects defense and minimum 1', () {
    final sim = BattleSim(a: mk('a', atk: 5, def: 0), b: mk('b', atk: 5, def: 4, cd: 9999), seed: 0);
    for (var i = 0; i < 60; i++) sim.step();
    // a should have dealt at least one 1-damage hit to b
    expect(sim.events.any((e) => e.source == 'a' && e.value >= 1), isTrue);
  });
}
