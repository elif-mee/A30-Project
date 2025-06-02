import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import 'login_screen.dart';
import 'cat_breeds_page.dart';
import 'favorites_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // Onglet sélectionné

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // Détecte si nous sommes en mode paysage
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Si l'utilisateur n'est pas connecté, on affiche l'écran de login
    if (appState.currentUser == null) {
      return LoginScreen();
    }

    // Choisir la page à afficher selon l'onglet sélectionné
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = CatBreedsPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // En mode paysage, on étend toujours le rail de navigation
        final shouldExtendRail = constraints.maxWidth >= 600 || isLandscape;

        return Scaffold(
          appBar: AppBar(
            title: Text('PawPedia'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text(appState.currentUser?.name ?? ''),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        appState.logout();
                      },
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              // Barre de navigation plus compacte en mode paysage
              SafeArea(
                child: NavigationRail(
                  extended: shouldExtendRail,
                  minExtendedWidth:
                      isLandscape ? 160 : 200, // Plus étroit en mode paysage
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.pets),
                      label: Text('Cat Breeds'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),

              // Contenu principal
              Expanded(
                child: Container(
                  // Gardez l'opacité pour voir la texture mais garder la lisibilité
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
