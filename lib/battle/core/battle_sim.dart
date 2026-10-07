import 'dart:math';

/// Deterministic battle engine core — no Flutter imports, no wall-clock time.
/// All time advances in 60 Hz ticks; RNG is seeded.
class EntityState {
  EntityState({
    required this.id,
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.range,
    required this.cooldown,
    required this.critChance,
  })  : hp = maxHp,
        energy = 0,
        cooldownRemaining = 0;

  final String id;
  final int maxHp;
  int hp;
  int energy;
  final int attack;
  final int defense;
  final double speed;
  final double range;
  final int cooldown;
  int cooldownRemaining;
  final double critChance;

  bool get isAlive => hp > 0;
}

enum EventKind { attack, crit, status, victory, tiebreak }

class BattleEvent {
  BattleEvent(this.tick, this.kind, this.source, this.target, this.value);
  final int tick;
  final EventKind kind;
  final String source;
  final String target;
  final int value;

  @override
  String toString() => 't=$tick ${kind.name} $source->$target $value';
}

class BattleSim {
  BattleSim({required this.a, required this.b, required this.seed, this.timeCapTicks = 60 * 45})
      : _rng = Random(seed);

  final EntityState a;
  final EntityState b;
  final int seed;
  final int timeCapTicks;
  final Random _rng;

  int tick = 0;
  final List<BattleEvent> events = [];
  bool finished = false;
  String? winnerId;

  /// Advance one 60 Hz step. Deterministic for a given seed and starting state.
  void step() {
    if (finished) return;
    tick++;

    _tickEntity(a, b);
    if (finished) return;
    _tickEntity(b, a);

    if (!a.isAlive && b.isAlive) _end(b.id, EventKind.victory);
    else if (!b.isAlive && a.isAlive) _end(a.id, EventKind.victory);
    else if (!a.isAlive && !b.isAlive) _end(null, EventKind.tiebreak);
    else if (tick >= timeCapTicks) _tiebreak();
  }

  void _tickEntity(EntityState self, EntityState other) {
    if (!self.isAlive || finished) return;
    if (self.cooldownRemaining > 0) self.cooldownRemaining--;
    self.energy = min(100, self.energy + 10);
    if (self.cooldownRemaining == 0 && self.energy >= 30) {
      _attack(self, other);
      self.cooldownRemaining = self.cooldown;
      self.energy -= 30;
    }
  }

  void _attack(EntityState src, EntityState dst) {
    final crit = _rng.nextDouble() < src.critChance;
    final raw = (src.attack * (crit ? 2 : 1) - dst.defense).clamp(1, 999).toInt();
    dst.hp = max(0, dst.hp - raw);
    events.add(BattleEvent(tick, crit ? EventKind.crit : EventKind.attack, src.id, dst.id, raw));
  }

  void _tiebreak() {
    final aScore = a.hp * 2 + (a.maxHp - a.hp) == 0 ? a.hp : a.hp;
    final bScore = b.hp;
    final winner = aScore == bScore ? null : (aScore > bScore ? a.id : b.id);
    events.add(BattleEvent(tick, EventKind.tiebreak, 'system', winner ?? 'draw', a.hp - b.hp));
    _end(winner, EventKind.tiebreak);
  }

  void _end(String? winner, EventKind kind) {
    finished = true;
    winnerId = winner;
    if (kind == EventKind.victory && winner != null) {
      events.add(BattleEvent(tick, EventKind.victory, winner, 'arena', 0));
    }
  }
}
