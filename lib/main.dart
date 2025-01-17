import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_pokedex_flutter/services/pokemon.service.dart';
import 'package:provider/provider.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pokedex'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: Provider.of<PokemonService>(context, listen: false).getPokemon(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (snapshot.connectionState != ConnectionState.done) return Text('Loading...');
            if (snapshot.data == null) return Text('No pokemon :(');
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data![index].name);
              },
            );
          },
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