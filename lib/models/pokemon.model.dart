class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final int? evolvesFromId;
  final List<int>? evolvesToIds;

  Pokemon({required this.id, required this.name, required this.types, required this.evolvesFromId, required this.evolvesToIds});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> types = json['types'].cast<String>();
    List<int>? evolvesToIds = json['evolvesToIds']?.cast<int>();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: types,
      evolvesFromId: json['evolvesFromId'],
      evolvesToIds: evolvesToIds
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'types': types,
      'evolvesFromId': evolvesFromId,
      'evolvesToIds': evolvesToIds
    };
  }
}
