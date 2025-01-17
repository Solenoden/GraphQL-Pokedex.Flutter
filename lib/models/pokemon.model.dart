class Pokemon {
  final int id;
  final String name;
  final List<String> types;

  Pokemon({required this.id, required this.name, required this.types});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> types = json['types'].cast<String>();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: types,
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
