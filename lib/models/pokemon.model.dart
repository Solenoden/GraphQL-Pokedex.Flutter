class Pokemon {
  final int id;
  final String name;
  final String? types;

  Pokemon({required this.id, required this.name, required this.types});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: json['types'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'types': types,
    };
  }
}
