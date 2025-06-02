import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../models/cat_breed.dart';
import '../widgets/cat_info_card.dart';
import '../widgets/cat_info_landscape.dart'; // Nouveau widget pour le mode paysage

class CatBreedsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    // Détecte si l'écran est en mode paysage ou portrait
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Titre principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets_rounded, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 8),
                Text(
                  'Cat Breeds Collection',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Dropdown pour choisir une race de chat (moins haut en mode paysage)
          Container(
            width: isLandscape ? 400 : 300,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: isLandscape ? 2 : 5),
            margin: EdgeInsets.only(bottom: isLandscape ? 8 : 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 3,
                )
              ],
            ),
            child: DropdownButton<CatBreed>(
              hint: Text(
                'Select a Cat Breed',
                style: TextStyle(color: Colors.grey[700]),
              ),
              value: null,
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down),
              items: appState.catBreeds.map((CatBreed breed) {
                return DropdownMenuItem<CatBreed>(
                  value: breed,
                  child: Text(breed.name),
                );
              }).toList(),
              onChanged: (CatBreed? selectedBreed) {
                if (selectedBreed != null) {
                  appState.fetchCatInfo(selectedBreed.name);
                }
              },
            ),
          ),

          // Si l'app est en train de charger, affiche un spinner
          if (appState.isLoading)
            CircularProgressIndicator()
          // Sinon, si les infos sont prêtes, on affiche la carte
          else if (appState.currentCatInfo != null)
            Expanded(
              child: SingleChildScrollView(
                child: isLandscape
                    ? CatInfoLandscape(catInfo: appState.currentCatInfo!) // Vue paysage
                    : CatInfoCard(catInfo: appState.currentCatInfo!),     // Vue portrait
              ),
            )
        ],
      ),
    );
  }
}