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
  late PokemonService pokemonService;

  late Future<List<List<Object?>>> _fetchDataFuture;
  late List<Pokemon> allPokemon;
  late List<PokemonType> types;

  List<PokemonType> selectedTypes = [];
  List<Pokemon> visiblePokemon = [];
  final List<String> typeCompositionOptions = ['Mono', 'Multi'];
  List<String> selectedTypeCompositions = ['Mono', 'Multi'];

  @override
  void initState() {
    super.initState();
    pokemonService = Provider.of<PokemonService>(context, listen: false);
    _fetchDataFuture = Future.wait(
        [pokemonService.getPokemon(), pokemonService.getPokemonTypes()]);
  }

  void _toggleTypeSelection(PokemonType type) {
    if (selectedTypes.contains(type)) {
      selectedTypes.remove(type);
    } else {
      selectedTypes.add(type);
    }

    _filterPokemon();
  }

  void _toggleCompositionFilter(String composition) {
    if (selectedTypeCompositions.contains(composition)) {
      selectedTypeCompositions.remove(composition);
    } else {
      selectedTypeCompositions.add(composition);
    }

    _filterPokemon();
  }

  void _filterPokemon() {
    setState(() {
      visiblePokemon = allPokemon.where((pokemon) {
        if (selectedTypeCompositions.isEmpty) return false;

        if (selectedTypeCompositions.length != typeCompositionOptions.length) {
          if (selectedTypeCompositions.contains('Mono') &&
              pokemon.types.length > 1) {
            return false;
          }
          if (selectedTypeCompositions.contains('Multi') &&
              pokemon.types.length == 1) {
            return false;
          }
        }

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
            selectedTypes.isNotEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.separated(
                        itemCount: visiblePokemon.length,
                        itemBuilder: (context, index) {
                          return PokemonPreviewTileWidget(visiblePokemon[index],
                              allTypes: types);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 25),
                      ),
                    ),
                  )
                : Text(
                    'Please select one or more Pokemon types.',
                    style: TextStyle(fontSize: 22),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildTypeFilter() {
    return ExpansionTile(
      leading: Icon(Icons.filter_alt),
      title: Text('Viewing ${selectedTypes.length} PokeTypes'),
      subtitle: selectedTypeCompositions.isEmpty
          ? Text('None')
          : Text(selectedTypeCompositions.length > 1
              ? selectedTypeCompositions.join(', ')
              : '${selectedTypeCompositions[0]} only'),
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
                  types.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: _buildPokemonTypePill(types[index]),
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
                children: typeCompositionOptions
                    .map(
                      (composition) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: GestureDetector(
                          onTap: () => _toggleCompositionFilter(composition),
                          child: Container(
                            width: 75,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:
                                  selectedTypeCompositions.contains(composition)
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
                                color: selectedTypeCompositions
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
  }

  Widget _buildPokemonTypePill(PokemonType type) {
    return GestureDetector(
      onTap: () => _toggleTypeSelection(type),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedTypes.contains(type) ? Colors.black45 : type.color,
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
