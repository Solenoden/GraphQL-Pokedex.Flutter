import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_pokedex_flutter/cubits/pokemon-type.cubit.dart';
import 'package:graphql_pokedex_flutter/cubits/pokemon.cubit.dart';
import 'package:provider/provider.dart';

import '../models/pokemon-type.model.dart';
import '../widgets/pokemon-preview-tile.widget.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pokemonCubit = Provider.of<PokemonCubit>(context, listen: false);
    pokemonCubit.fetchPokemon();

    return Column(
      children: [
        _buildTypeFilter(),
        Column(
          children: [
            BlocBuilder<PokemonCubit, PokemonCubitState>(
                builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(top: 8),
                child: state.isLoading
                    ? Text('loading Pokemon...')
                    : Text('Viewing ${state.visiblePokemon.length} Pokemon'),
              );
            })
          ],
        ),
        _buildVisiblePokemonList()
      ],
    );
  }

  Widget _buildTypeFilter() {
    return BlocBuilder<PokemonTypeCubit, PokemonTypeCubitState>(
        builder: (context, state) {
      var pokemonTypeCubit =
          Provider.of<PokemonTypeCubit>(context, listen: false);

      return ExpansionTile(
        leading: Icon(Icons.filter_alt),
        title: Text('Viewing ${state.selectedTypes.length} PokeTypes'),
        subtitle: state.selectedTypeCompositions.isEmpty
            ? Text('None')
            : Text(state.selectedTypeCompositions.length > 1
                ? state.selectedTypeCompositions.join(', ')
                : '${state.selectedTypeCompositions[0]} only'),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              children: [
                Text(
                  'PokeTypes:',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    state.allTypes.length,
                    (index) {
                      var type = state.allTypes[index];
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: _buildPokemonTypePill(
                          type,
                          state.selectedTypes.contains(type),
                          () => pokemonTypeCubit.toggleFilter(type, null),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text('Type Composition:',
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pokemonTypeCubit.typeCompositionOptions
                      .map(
                        (composition) => Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: GestureDetector(
                            onTap: () => pokemonTypeCubit.toggleFilter(
                                null, composition),
                            child: Container(
                              width: 75,
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: state.selectedTypeCompositions
                                        .contains(composition)
                                    ? Colors.black87
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black87,
                                  width: 3,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                composition,
                                style: TextStyle(
                                  color: state.selectedTypeCompositions
                                          .contains(composition)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget _buildVisiblePokemonList() {
    return BlocSelector<PokemonTypeCubit, PokemonTypeCubitState,
            List<PokemonType>>(
        selector: (typeState) => typeState.allTypes,
        builder: (context, allTypes) {
          return BlocBuilder<PokemonCubit, PokemonCubitState>(
              builder: (context, state) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemCount: state.visiblePokemon.length,
                  itemBuilder: (context, index) {
                    return PokemonPreviewTileWidget(state.visiblePokemon[index],
                        allTypes: allTypes);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 25),
                ),
              ),
            );
          });
        });
  }

  Widget _buildPokemonTypePill(
      PokemonType type, bool isSelected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black45 : type.color,
            width: 3,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          type.name.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
