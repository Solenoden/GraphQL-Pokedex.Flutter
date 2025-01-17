import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_pokedex_flutter/models/pokemon.model.dart';

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
}