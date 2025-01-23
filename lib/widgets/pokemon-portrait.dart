import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubits/pokemon-type.cubit.dart';
import '../enums/portrait-type.enum.dart';
import '../models/pokemon-type.model.dart';
import '../models/pokemon.model.dart';

class PokemonPortraitWidget extends StatelessWidget {
  final Pokemon pokemon;
  final double width;
  final double height;
  final PortraitType type;
  late List<PokemonType> types;
  final Function()? onTap;

  PokemonPortraitWidget(this.pokemon, {super.key, this.width = 75, this.height = 75, this.type = PortraitType.imageOnly, this.onTap});

  @override
  Widget build(BuildContext context) {
    var pokemonTypeCubit = Provider.of<PokemonTypeCubit>(context, listen: false);
    types = pokemonTypeCubit.getTypesForPokemon(pokemon);

    var image = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
    );

    return GestureDetector(
      onTap: onTap,
      child: (() {
        switch (type) {
          case PortraitType.imageOnly:
            return image;
          case PortraitType.circleBorder:
            List<Color> colors = [];
            for (var pokemonType in types) {
              colors.add(pokemonType.color);
              colors.add(pokemonType.color);
            }
            return Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: types.length == 1 ? types[0].color : null,
                gradient: types.length > 1 ? SweepGradient(
                  startAngle: 0.5,
                  colors: colors,
                  stops: [0, 0.5, 0.5, 1],
                ) : null,
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                ),
              ),
              child: image,
            );
        }
      })(),
    );
  }

  String get imageUrl =>
      'https://www.pokemon.com/static-assets/content-assets/cms2/img/pokedex/full/${pokemon.id.toString().padLeft(3, '0')}.png';
}
