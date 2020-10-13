import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sumobot/repositories/robots/firestore_robots_step_repository.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/models/step.dart' as Step;
import 'package:sumobot/robot/cubit/robot_state.dart';

class RobotCubit extends Cubit<RobotState> {
  RobotCubit(Robot robot, this._stepsRepository)
      : super(RobotState(
          robot: robot,
          image: Image.asset(
            "assets/kit-sumobot.jpg",
            fit: BoxFit.fitWidth,
          ),
        )) {
    _stepsRepository.step(robot).listen((Step.Step step) {
      emit(state.copyWith(step: step));
    });
  }

  final FirestoreRobotsStepsRepository _stepsRepository;

  final picker = ImagePicker();

  void delete(BuildContext context) async {
    await showDialog(context: context, builder: (context) => AlertDialog(title: Text("Ceci n'est pas encore implémenté")));
  }

  void changePhoto() async {
    await picker.getImage(source: ImageSource.gallery);
  }
}
