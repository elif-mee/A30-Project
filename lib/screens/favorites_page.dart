import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import 'cat_details_page.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Si l'utilisateur n'est pas connecté ou n'a aucun favori
    if (appState.currentUser == null || appState.currentUser!.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Add some cats to your favorites!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Favorite Cats',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: isLandscape ? 8 : 16),
          Text(
            'Click on a cat to view its details',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: isLandscape ? 12 : 24),
          Expanded(
            child: isLandscape
                // Grid view pour mode paysage (2 colonnes)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: appState.currentUser!.favorites.length,
                    itemBuilder: (context, index) {
                      String catBreedName = appState.currentUser!.favorites[index];
                      return _buildFavoriteCard(context, catBreedName, appState, isCompact: true);
                    },
                  )
                // Liste pour mode portrait
                : ListView.builder(
                    itemCount: appState.currentUser!.favorites.length,
                    itemBuilder: (context, index) {
                      String catBreedName = appState.currentUser!.favorites[index];
                      return _buildFavoriteCard(context, catBreedName, appState);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Fonction d'aide pour construire les cartes de favoris
  Widget _buildFavoriteCard(BuildContext context, String catBreedName, MyAppState appState, {bool isCompact = false}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: isCompact ? 4 : 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: isCompact ? 4 : 8
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.pets,
            color: Colors.white,
          ),
        ),
        title: Text(
          catBreedName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isCompact ? 14 : 16,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Supprimer un favori
            appState.removeFromFavorites(catBreedName);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Removed from favorites')),
            );
          },
          tooltip: 'Remove from favorites',
        ),
        onTap: () {
          // Aller à la page de détails
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CatDetailsPage(breedName: catBreedName),
            ),
          );
        },
      ),
    );
  }
}