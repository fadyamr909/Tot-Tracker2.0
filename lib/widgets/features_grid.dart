import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tottracker/widgets/feature_item.dart';
import '/providers/features.dart' show Features ;

class FeaturesGrid extends StatelessWidget {
  final bool showFavs;
  FeaturesGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final featureData = Provider.of<Features>(context);
    final features = showFavs ? featureData.showFavItems : featureData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: features.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: features[i],
        child: FeatureItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 15 / 14,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
    
  }
}
