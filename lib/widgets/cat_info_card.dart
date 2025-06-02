import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../models/cat_info.dart';
import '../widgets/info_row.dart';

class CatInfoCard extends StatelessWidget {
  final CatInfo catInfo;

  const CatInfoCard({Key? key, required this.catInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isFavorite = appState.isBreedFavorite(catInfo.name);

    return Container(
      margin: EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cat Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                catInfo.imageLink,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print("Error loading image: $error");
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 8),
                          Text("Image not available")
                        ],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
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
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cat Name
                  Text(
                    catInfo.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Divider(height: 24),
                  
                  // Cat Details
                  InfoRow(label: 'Origin', value: catInfo.origin),
                  InfoRow(label: 'Max Life Expectancy', value: "${catInfo.maxLifeExpectancy} years"),
                  InfoRow(label: 'Length', value: "${catInfo.length} inches"),
                  
                  SizedBox(height: 20),
                  
                  // Favorite Button
                  Center(
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
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: isFavorite ? Colors.pink[100] : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}