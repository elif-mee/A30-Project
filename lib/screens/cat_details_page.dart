import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_state.dart';
import '../widgets/cat_info_card.dart';
import '../widgets/cat_info_landscape.dart'; // Ajout du widget pour mode paysage

class CatDetailsPage extends StatefulWidget {
  final String breedName;

  const CatDetailsPage({Key? key, required this.breedName}) : super(key: key);

  @override
  CatDetailsPageState createState() => CatDetailsPageState();
}

class CatDetailsPageState extends State<CatDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Lorsque la page est ouverte, on charge les infos du chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyAppState>(context, listen: false)
          .fetchCatInfo(widget.breedName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // Détecte si l'écran est en mode paysage
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.breedName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
          child: appState.isLoading
              ? CircularProgressIndicator()
              : appState.currentCatInfo != null
                  ? SingleChildScrollView(
                      child: isLandscape
                          ? CatInfoLandscape(catInfo: appState.currentCatInfo!) // Mode paysage
                          : CatInfoCard(catInfo: appState.currentCatInfo!), // Mode portrait
                    )
                  : Text('Could not load cat information'),
        ),
      ),
    );
  }
}