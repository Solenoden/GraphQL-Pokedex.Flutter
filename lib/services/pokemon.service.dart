import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_pokedex_flutter/models/pokemon.model.dart';

import '../models/pokemon-type.model.dart';

class PokemonService {
  final GraphQLClient graphQlClient;

  PokemonService(this.graphQlClient);

  Future<List<Pokemon>> getPokemon() async {
    var result = await graphQlClient.query(QueryOptions(document: gql(r'''
      query PokemonGetAll {
          pokemonGetAll {
              id
              name,
              types
          }
      }
    ''')));
    var pokemonJson = result.data!['pokemonGetAll'];
    if (pokemonJson.isEmpty) return [];

    List<Pokemon> pokemonList = [];
    pokemonJson.forEach((pokemon) {
      if (pokemon is Map<String, dynamic>) {
        pokemonList.add(Pokemon.fromJson(pokemon));
      }
    });

    return pokemonList;
  }

  Future<List<PokemonType>> getPokemonTypes() async {
    var result = await graphQlClient.query(QueryOptions(document: gql(r'''
      query PokemonTypeGetAll {
        pokemonTypeGetAll {
            name
            weaknesses
            strengths
            color
        }
      }
    ''')));
    var json = result.data!['pokemonTypeGetAll'];
    if (json.isEmpty) return [];

    List<PokemonType> typeList = [];
    json.forEach((type) {
      if (type is Map<String, dynamic>) {
        typeList.add(PokemonType.fromJson(type));
      }
    });

    return typeList;
  }
}