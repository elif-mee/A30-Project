import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../models/cat_info.dart';
import '../widgets/info_row.dart';

class CatInfoLandscape extends StatelessWidget {
  final CatInfo catInfo;

  const CatInfoLandscape({Key? key, required this.catInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isFavorite = appState.isBreedFavorite(catInfo.name);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Titre (nom du chat)
              Text(
                catInfo.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 12),
              
              // Layout Paysage: Image à gauche, Infos à droite
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image du chat (à gauche, carré)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      catInfo.imageLink,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 140,
                          width: 140,
                          color: Colors.grey[200],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 30,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 4),
                                Text("Image not available", 
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 140,
                          width: 140,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(width: 16),
                  
                  // Infos du chat (à droite)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: 'Origin', value: catInfo.origin),
                        InfoRow(label: 'Max Life Expectancy', value: "${catInfo.maxLifeExpectancy} years"),
                        InfoRow(label: 'Length', value: "${catInfo.length} inches"),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Bouton Favoris (en bas, pleine largeur)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isFavorite) {
                      appState.removeFromFavorites(catInfo.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Removed from favorites')),
                      );
                    } else {
                      appState.addToFavorites(catInfo.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to favorites!')),
                      );
                    }
                  },
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  label: Text(isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: isFavorite ? Colors.pink[100] : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}