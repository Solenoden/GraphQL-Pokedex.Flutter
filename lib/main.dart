import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_pokedex_flutter/cubits/pokemon-type.cubit.dart';
import 'package:graphql_pokedex_flutter/pages/pokemon-list.page.dart';
import 'package:graphql_pokedex_flutter/services/pokemon.service.dart';
import 'package:provider/provider.dart';

import 'cubits/pokemon.cubit.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  var graphQlClient = await initGraphQl();

  runApp(
    MultiProvider(
      providers: [
        Provider<GraphQLClient>(create: (context) => graphQlClient),
        Provider<PokemonService>(create: (context) => PokemonService(Provider.of<GraphQLClient>(context, listen: false))),
      ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PokemonCubit(Provider.of<PokemonService>(context, listen: false))),
        BlocProvider(create: (context) => PokemonTypeCubit(Provider.of<PokemonService>(context, listen: false))),
      ],
      child: App()
    ),
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.black87,
            onPrimary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: BlocListener<PokemonTypeCubit, PokemonTypeCubitState>(
          listener: (context, state) {
            Provider.of<PokemonCubit>(context, listen: false).filterPokemon(state.selectedTypes, state.selectedTypeCompositions);
          },
          child: MyHomePage(title: 'Pokedex: the Original 151'),
      ),
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
  void initState() {
    super.initState();
    Provider.of<PokemonTypeCubit>(context, listen: false).fetchTypes();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          bottom: TabBar(
            indicatorColor: Colors.deepOrange,
            tabs: [
              Tab(icon: Icon(Icons.menu_book, color: Colors.deepOrange)),
            ],
          ),
        ),
        body: Center(
            child: TabBarView(
          children: [
            PokemonListPage()
          ],
        )),
      ),
    );
  }
}

Future<GraphQLClient> initGraphQl() async {
  await initHiveForFlutter();
  final client = GraphQLClient(
    link: HttpLink('${dotenv.env['API_BASE_URL']}/graphql'),
    cache: GraphQLCache(store: HiveStore()),
  );
  return client;
}