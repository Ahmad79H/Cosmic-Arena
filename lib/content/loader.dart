import 'dart:convert';

class EntityDef {
  EntityDef(this.json);
  final Map<String, dynamic> json;

  String get id => json['id'] as String;
  String get name => json['name'] as String;
  int get hp => json['hp'] as int;
  int get attack => json['attack'] as int;
  int get defense => json['defense'] as int;
  double get speed => (json['speed'] as num).toDouble();
  double get range => (json['range'] as num).toDouble();
  int get cooldown => json['cooldown'] as int;
  double get critChance => (json['critChance'] as num).toDouble();

  static EntityDef fromJson(Map<String, dynamic> json) {
    const requiredKeys = ['id', 'name', 'hp', 'attack', 'defense', 'speed', 'range', 'cooldown', 'critChance'];
    for (final k in requiredKeys) {
      if (!json.containsKey(k)) {
        throw FormatException('Entity definition missing required key: $k');
      }
    }
    return EntityDef(json);
  }
}

class ContentLoader {
  static EntityDef parseEntity(String raw) => EntityDef.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
