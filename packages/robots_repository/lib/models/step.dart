import 'package:equatable/equatable.dart';
import 'package:robots_repository/entities/step_entity.dart';

class Step extends Equatable {
  const Step({
    this.isPayed = StepStatus.UNKNOWN,
    this.isValidated = StepStatus.UNKNOWN,
    this.isRegistered = StepStatus.UNKNOWN,
  });

  final StepStatus isPayed;
  final StepStatus isValidated;
  final StepStatus isRegistered;

  static const empty = Step(
      isValidated: StepStatus.UNKNOWN,
      isPayed: StepStatus.UNKNOWN,
      isRegistered: StepStatus.UNKNOWN);

  Step changeStepFromEntity(StepEntity stepEntity) {
    switch (stepEntity.name) {
      case "pay":
        return copyWith(isPayed: stepEntity.status);
      case "valid":
        return copyWith(isPayed: stepEntity.status);
      case "register":
        return copyWith(isRegistered: stepEntity.status);
    }
    return this;
  }

  Step copyWith({
    StepStatus? isPayed,
    StepStatus? isValidated,
    StepStatus? isRegistered,
  }) {
    return Step(
      isPayed: isPayed ?? this.isPayed,
      isValidated: isValidated ?? this.isValidated,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }

  @override
  List<Object> get props => [isPayed, isValidated, isRegistered];
}
