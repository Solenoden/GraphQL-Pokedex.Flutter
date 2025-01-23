import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_pokedex_flutter/models/pokemon-type.model.dart';
import 'package:graphql_pokedex_flutter/pages/pokemon-info.page.dart';

import '../models/pokemon.model.dart';

class PokemonPreviewTileWidget extends StatelessWidget {
  final Pokemon pokemon;
  final List<PokemonType> types;

  PokemonPreviewTileWidget(this.pokemon,
      {super.key, required List<PokemonType> allTypes})
      : types = pokemon.types
            .map((typeName) =>
                allTypes.firstWhere((type) => type.name == typeName))
            .toList();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PokemonInfoPage(pokemon))
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: types.length == 1 ? types[0].color : null,
            gradient: types.length > 1
                ? LinearGradient(
                    colors: types.map((x) => x.color).toList(),
                    begin: Alignment.center)
                : null),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                height: 75,
                width: 75,
              ),
              SizedBox(width: 16),
              Text(
                pokemon.name,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Expanded(
                child: Text(
                  '#${pokemon.id}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.white.withOpacity(0.4), // Make it semi-transparent
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get imageUrl =>
      'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/${pokemon.id.toString().padLeft(3, '0')}.png';
}
