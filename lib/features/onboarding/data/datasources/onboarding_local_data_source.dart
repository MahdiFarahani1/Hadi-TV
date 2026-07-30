import 'package:hive_flutter/hive_flutter.dart';
import 'package:haditv/core/service/storage/hive_initializer.dart';

abstract class OnboardingLocalDataSource {
  bool isOnboardingCompleted();
  Future<void> setOnboardingCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  Box get _settingsBox => Hive.box(HiveInitializer.settingsBoxName);

  @override
  bool isOnboardingCompleted() {
    return _settingsBox.get(_keyOnboardingCompleted, defaultValue: false)
        as bool;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await _settingsBox.put(_keyOnboardingCompleted, true);
  }
}
