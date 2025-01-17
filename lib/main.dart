import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_pokedex_flutter/services/pokemon.service.dart';
import 'package:graphql_pokedex_flutter/widgets/pokemon-preview-tile.widget.dart';
import 'package:provider/provider.dart';

import 'models/pokemon-type.model.dart';
import 'models/pokemon.model.dart';

void main() async {
  var graphQlClient = await initGraphQl();

  runApp(
    MultiProvider(
      providers: [
        Provider<GraphQLClient>(create: (context) => graphQlClient),
        Provider<PokemonService>(create: (context) => PokemonService(Provider.of<GraphQLClient>(context, listen: false))),
      ],
      child: App()
    )
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, primary: Colors.black87, onPrimary: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pokedex: the Original 151'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var pokemonService = Provider.of<PokemonService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder(
            future: Future.wait([pokemonService.getPokemon(), pokemonService.getPokemonTypes()]),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (snapshot.connectionState != ConnectionState.done) return Text('Loading...');
              if (snapshot.data == null || snapshot.data![0] == null) return Text('No pokemon :(');
              if (snapshot.data![1] == null) return Text('No pokemon types :(');

              return ListView.separated(
                itemCount: snapshot.data![0].length,
                itemBuilder: (context, index) {
                  return PokemonPreviewTileWidget(
                    snapshot.data![0][index] as Pokemon,
                    allTypes: snapshot.data![1] as List<PokemonType>,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 25,),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<GraphQLClient> initGraphQl() async {
  await initHiveForFlutter();
  final client = GraphQLClient(
    link: HttpLink('http://192.168.50.200:3000/graphql'),
    cache: GraphQLCache(store: HiveStore()),
  );
  return client;
}