import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveInitializer {
  static const String settingsBoxName = 'settings_box';
  static const String bookmarksBoxName = 'bookmarks_box';
  static const String recentSearchesBoxName = 'recent_searches_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox(settingsBoxName);
    await Hive.openBox(bookmarksBoxName);
    await Hive.openBox(recentSearchesBoxName);
  }
}
