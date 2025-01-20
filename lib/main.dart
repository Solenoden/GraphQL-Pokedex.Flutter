import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_pokedex_flutter/pages/pokemon-list.page.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, primary: Colors.black87, onPrimary: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pokedex: the Original 151'),
      debugShowCheckedModeBanner: false,
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
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Center(
        child: PokemonListPage(),
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