import 'package:hive_flutter/hive_flutter.dart';
import 'package:haditv/core/service/storage/hive_initializer.dart';

abstract class SearchLocalDataSource {
  List<String> getRecentSearches();
  Future<void> saveRecentSearches(List<String> searches);
  Future<void> clearRecentSearches();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  Box get _recentSearchesBox => Hive.box(HiveInitializer.recentSearchesBoxName);

  @override
  List<String> getRecentSearches() {
    final list = _recentSearchesBox.get('searches', defaultValue: []) as List;
    return list.cast<String>();
  }

  @override
  Future<void> saveRecentSearches(List<String> searches) async {
    await _recentSearchesBox.put('searches', searches);
  }

  @override
  Future<void> clearRecentSearches() async {
    await _recentSearchesBox.clear();
  }
}
