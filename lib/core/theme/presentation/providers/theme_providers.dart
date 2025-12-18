import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/theme_asset_data_source.dart';


final themeAssetDataSourceProvider = Provider<ThemeAssetDataSource>((ref) {
  return ThemeAssetDataSourceImpl();
});

