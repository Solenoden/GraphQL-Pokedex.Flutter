import 'package:graphql_pokedex_flutter/cubits/app-cubit.abstract.dart';

import '../models/pokemon-type.model.dart';
import '../models/pokemon.model.dart';
import '../services/pokemon.service.dart';

class PokemonTypeCubitState extends AppCubitState {
  List<PokemonType> allTypes = [];
  List<PokemonType> selectedTypes = [];
  List<String> selectedTypeCompositions = ['Mono', 'Multi'];

  PokemonTypeCubitState({
    required this.allTypes,
    required this.selectedTypes,
    required this.selectedTypeCompositions,
    required bool isLoading
  }) : super(isLoading);

  factory PokemonTypeCubitState.initial() {
    return PokemonTypeCubitState(
        allTypes: [],
        selectedTypes: [],
        selectedTypeCompositions: ['Mono', 'Multi'],
        isLoading: false
    );
  }

  @override
  PokemonTypeCubitState clone() {
    return PokemonTypeCubitState(
      allTypes: this.allTypes,
      selectedTypes: this.selectedTypes,
      selectedTypeCompositions: this.selectedTypeCompositions,
      isLoading: this.isLoading
    );
  }
}

class PokemonTypeCubit extends AppCubit<PokemonTypeCubitState> {
  PokemonService pokemonService;
  late PokemonTypeCubitState debugState;

  final List<String> typeCompositionOptions = ['Mono', 'Multi'];

  PokemonTypeCubit(this.pokemonService) : super(PokemonTypeCubitState.initial());

  void fetchTypes() async {
    if (state.allTypes.isNotEmpty) return;

    emit(state, isLoading: true);
    var types = await pokemonService.getPokemonTypes();

    state.allTypes = types;
    emit(state);
  }

  void toggleFilter(PokemonType? type, String? typeComposition) async {
    if (type != null) {
      state.selectedTypes.contains(type)
          ? state.selectedTypes.remove(type)
          : state.selectedTypes.add(type);
    }

    if (typeComposition != null) {
      state.selectedTypeCompositions.contains(typeComposition)
          ? state.selectedTypeCompositions.remove(typeComposition)
          : state.selectedTypeCompositions.add(typeComposition);
    }

    emit(state);
  }

  List<PokemonType> getTypesForPokemon(Pokemon pokemon) {
    return pokemon.types
        .map((typeName) =>
            state.allTypes.firstWhere((type) => type.name == typeName))
        .toList();
  }

  List<PokemonType> getWeaknessTypesOfPokemon(Pokemon pokemon) {
    var pokemonTypes = getTypesForPokemon(pokemon);
    List<String> weaknessNames = [];
    for (var pokemonType in pokemonTypes) {
      weaknessNames.addAll(pokemonType.weaknesses);
    }

    List<PokemonType> weaknesses = [];
    for (var weaknessName in weaknessNames) {
      weaknesses.add(state.allTypes.firstWhere((type) => type.name == weaknessName));
    }

    return weaknesses;
  }
}