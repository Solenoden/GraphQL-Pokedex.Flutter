import 'dart:ui';

import '../utils.dart';

class PokemonType {
  final String name;
  final List<String> weaknesses;
  final List<String> strengths;
  final Color color;

  PokemonType({
    required this.name,
    required this.weaknesses,
    required this.strengths,
    required this.color
  });

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    List<String> weaknesses = json['weaknesses'].cast<String>();
    List<String> strengths = json['strengths'].cast<String>();

    return PokemonType(
      name: json['name'],
      weaknesses: weaknesses,
      strengths: strengths,
      color: Utils.hexToColor(json['color'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weaknesses': weaknesses,
      'strengths': strengths,
      'color': color.toString()
    };
  }
}