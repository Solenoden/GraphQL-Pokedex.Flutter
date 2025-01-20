import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon-type.model.dart';
import '../models/pokemon.model.dart';
import '../services/pokemon.service.dart';
import '../widgets/pokemon-preview-tile.widget.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  List<Pokemon> visiblePokemon = [];
  late List<Pokemon> allPokemon;
  late List<PokemonType> types;

  late PokemonService pokemonService;
  late Future<List<List<Object?>>> _fetchDataFuture;

  final List<PokemonType> selectedTypes = [];

  @override
  void initState() {
    super.initState();
    pokemonService = Provider.of<PokemonService>(context, listen: false);
    _fetchDataFuture = Future.wait(
        [pokemonService.getPokemon(), pokemonService.getPokemonTypes()]);
  }

  void _toggleTypeSelection(PokemonType type) {
    setState(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }

      visiblePokemon = allPokemon.where((pokemon) {
        for (var type in pokemon.types) {
          if (selectedTypes.any((x) => x.name == type)) return true;
        }
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.connectionState != ConnectionState.done)
          return Text('Loading...');
        if (snapshot.data == null || snapshot.data![0] == null)
          return Text('No pokemon :(');
        if (snapshot.data![1] == null) return Text('No pokemon types :(');

        allPokemon = snapshot.data![0] as List<Pokemon>;
        types = snapshot.data![1] as List<PokemonType>;

        return Column(
          children: [
            _buildTypeFilter(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemCount: visiblePokemon.length,
                  itemBuilder: (context, index) {
                    return PokemonPreviewTileWidget(visiblePokemon[index],
                        allTypes: types);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 25),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTypeFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              types.length,
              (index) {
                var type = types[index];
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () => _toggleTypeSelection(type),
                    child: Container(
                      width: 75,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: type.color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedTypes.contains(type)
                                ? Colors.black45
                                : type.color,
                            width: 3,
                          )),
                      alignment: Alignment.center,
                      child: Text(type.name),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
