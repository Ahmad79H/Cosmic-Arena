import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'battle/core/battle_sim.dart';

void main() => runApp(const CosmicArenaApp());

class CosmicArenaApp extends StatelessWidget {
  const CosmicArenaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Cosmic Arena',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF05070F),
          primaryColor: const Color(0xFF00E5FF),
        ),
        home: const SetupScreen(),
      );
}

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cosmic Arena')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Pick two. Change one rule. See the verdict.')
                  .animate()
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BattleScreen()),
                ),
                child: const Text('Start Battle'),
              ).animate().scale(duration: 300.ms),
            ],
          ),
        ),
      );
}

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late final BattleSim sim;

  @override
  void initState() {
    super.initState();
    sim = BattleSim(
      a: EntityState(
        id: 'solaris', maxHp: 100, attack: 14, defense: 4,
        speed: 1.0, range: 2.0, cooldown: 60, critChance: 0.15,
      ),
      b: EntityState(
        id: 'nuva', maxHp: 100, attack: 11, defense: 6,
        speed: 1.2, range: 1.5, cooldown: 50, critChance: 0.20,
      ),
      seed: 42,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Battle')),
        body: Center(
          child: AnimatedBuilder(
            animation: const AlwaysStoppedAnimation(0),
            builder: (_, __) => Text(
              'tick ${sim.tick}  a:${sim.a.hp} b:${sim.b.hp}  events:${sim.events.length}',
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            for (var i = 0; i < 60 && !sim.finished; i++) sim.step();
          }),
          child: const Icon(Icons.play_arrow),
        ),
      );
}
