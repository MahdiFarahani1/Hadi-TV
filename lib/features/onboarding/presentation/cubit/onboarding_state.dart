import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  final int pageIndex;

  const OnboardingState({this.pageIndex = 0});

  @override
  List<Object?> get props => [pageIndex];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial({super.pageIndex = 0});
}

class OnboardingPageChanged extends OnboardingState {
  const OnboardingPageChanged(int index) : super(pageIndex: index);
}

class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState() : super(pageIndex: 2);
}
