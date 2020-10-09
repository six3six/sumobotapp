import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sumobot/repositories/robots/entities/step_entity.dart';

class Step extends Equatable {
  const Step({
    this.isPayed = StepStatus.UNKNOWN,
    this.isValidated = StepStatus.UNKNOWN,
    this.isRegistered = StepStatus.UNKNOWN,
  })  : assert(isPayed != null),
        assert(isValidated != null),
        assert(isRegistered != null);

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
        break;
      case "valid":
        return copyWith(isPayed: stepEntity.status);
        break;
      case "register":
        return copyWith(isRegistered: stepEntity.status);
        break;
    }
    return this;
  }

  Step copyWith({
    StepStatus isPayed,
    StepStatus isValidated,
    StepStatus isRegistered,
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
