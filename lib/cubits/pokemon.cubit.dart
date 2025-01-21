import 'package:graphql_pokedex_flutter/models/pokemon.model.dart';

import '../models/pokemon-type.model.dart';
import '../services/pokemon.service.dart';
import 'app-cubit.abstract.dart';

class PokemonCubitState extends AppCubitState {
  List<Pokemon> allPokemon;
  List<Pokemon> visiblePokemon;

  PokemonCubitState({
    required this.allPokemon,
    required this.visiblePokemon,
    required bool isLoading
  }) : super(isLoading);

  factory PokemonCubitState.initial() {
    return PokemonCubitState(
      allPokemon: [],
      visiblePokemon: [],
      isLoading: false
    );
  }

  @override
  PokemonCubitState clone() {
    return PokemonCubitState(
      allPokemon: this.allPokemon,
      visiblePokemon: this.visiblePokemon,
      isLoading: this.isLoading
    );
  }
}

class PokemonCubit extends AppCubit<PokemonCubitState> {
  PokemonService pokemonService;
  late PokemonCubitState debugState;

  final List<String> typeCompositionOptions = ['Mono', 'Multi'];

  PokemonCubit(this.pokemonService) : super(PokemonCubitState.initial());

  void fetchPokemon() async {
    if (state.allPokemon.isNotEmpty) return;

    emit(state, isLoading: true);
    var pokemons = await pokemonService.getPokemon();

    state.allPokemon = pokemons;
    emit(state);
  }

  void filterPokemon(List<PokemonType> selectedTypes, List<String> selectedTypeCompositions) {
    if (selectedTypeCompositions.isEmpty || selectedTypes.isEmpty) {
      state.visiblePokemon = [];
    } else {
      emit(state, isLoading: true);
      var isCompositionFiltered = selectedTypeCompositions.length != typeCompositionOptions.length;
      var isMonoAllowed = selectedTypeCompositions.contains('Mono');
      var isMultiAllowed = selectedTypeCompositions.contains('Multi');
      var selectedTypeSet = selectedTypes.map((type) => type.name).toSet();

      state.visiblePokemon = state.allPokemon.where((pokemon) {
        if (isCompositionFiltered) {
          if (isMonoAllowed && pokemon.types.length > 1) {
            return false;
          }
          if (isMultiAllowed && pokemon.types.length == 1) {
            return false;
          }
        }

        for (var type in pokemon.types) {
          if (selectedTypeSet.contains(type)) return true;
        }

        return false;
      }).toList();
    }

    emit(state);
  }
}