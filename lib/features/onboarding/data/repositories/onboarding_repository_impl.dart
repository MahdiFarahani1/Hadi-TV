import 'package:haditv/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:haditv/features/onboarding/data/datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  bool isOnboardingCompleted() => localDataSource.isOnboardingCompleted();

  @override
  Future<void> completeOnboarding() => localDataSource.setOnboardingCompleted();
}
