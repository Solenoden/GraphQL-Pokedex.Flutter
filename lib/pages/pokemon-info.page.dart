import 'package:flutter/material.dart';
import 'package:graphql_pokedex_flutter/cubits/pokemon-type.cubit.dart';
import 'package:graphql_pokedex_flutter/cubits/pokemon.cubit.dart';
import 'package:graphql_pokedex_flutter/enums/portrait-type.enum.dart';
import 'package:graphql_pokedex_flutter/models/pokemon-type.model.dart';
import 'package:graphql_pokedex_flutter/widgets/pokemon-portrait.dart';
import 'package:graphql_pokedex_flutter/widgets/pokemon-type-pill.widget.dart';
import 'package:provider/provider.dart';

import '../models/pokemon.model.dart';

class PokemonInfoPage extends StatelessWidget {
  late PokemonCubit pokemonCubit;
  late PokemonTypeCubit pokemonTypeCubit;

  final Pokemon pokemon;

  late List<PokemonType> types;
  late List<PokemonType> weaknesses;

  PokemonInfoPage(this.pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    pokemonCubit = Provider.of<PokemonCubit>(context, listen: false);
    pokemonTypeCubit = Provider.of<PokemonTypeCubit>(context, listen: false);

    types = pokemonTypeCubit.getTypesForPokemon(pokemon);
    weaknesses = pokemonTypeCubit.getWeaknessTypesOfPokemon(pokemon);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Pokemon Info',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopBanner(context),
            _buildWeaknessesInfo(),
            _buildEvolutionTree(context)
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Column(
            children: [
              Image.asset(
                'assets/images/kanto_background.jpg',
                fit: BoxFit.fill,
                width: double.infinity,
                height: 200,
              ),
              Container(
                height: 200,
                padding: EdgeInsets.only(bottom: 20),
                color: Colors.black.withAlpha(200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      pokemon.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: 44, letterSpacing: 5),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: types
                          .map((type) => Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: PokemonTypePill(
                                  type,
                                  isSelected: true,
                                  onTap: null,
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: PokemonPortraitWidget(
              pokemon,
              height: 150,
              width: 150,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaknessesInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Weaknesses', textAlign: TextAlign.left, style: TextStyle(fontSize: 22),),
          Padding(
            padding: EdgeInsets.all(10),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: weaknesses.map((weakness) => Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: PokemonTypePill(weakness, isSelected: false,),
              )).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEvolutionTree(BuildContext context) {
    var evolutionStages = pokemonCubit.getEvolutionTree(pokemon);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: Colors.black87),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: evolutionStages.asMap().entries.map(
          (stage) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                      'Stage ${stage.key + 1}',
                      style: TextStyle(color: Colors.white, fontSize: 20)
                  ),
                ),
                ...stage.value.map((pokemonInStage) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PokemonPortraitWidget(
                      pokemonInStage,
                      type: PortraitType.circleBorder,
                      width: 64,
                      height: 64,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => PokemonInfoPage(pokemonInStage))
                        );
                      },
                    ),
                  );
                })
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
