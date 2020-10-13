import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sumobot/repositories/robots/firestore_robots_repository.dart';
import 'package:sumobot/repositories/robots/firestore_robots_step_repository.dart';
import 'package:sumobot/repositories/robots/models/robot.dart';
import 'package:sumobot/repositories/robots/models/step.dart' as Step;
import 'package:sumobot/robot/cubit/robot_state.dart';

class RobotCubit extends Cubit<RobotState> {
  RobotCubit(Robot robot, this._stepsRepository, this._robotsRepository)
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

    _robotsRepository.getImage(robot).then((value) {
      final File image = File(value);
      if (image.existsSync())
        emit(state.copyWith(image: Image.file(image)));
      else
        emit(state.copyWith(image: Icon(FontAwesomeIcons.question)));
    });
  }

  final FirestoreRobotsStepsRepository _stepsRepository;
  final FirestoreRobotsRepository _robotsRepository;

  final picker = ImagePicker();

  void delete(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text("Ceci n'est pas encore implémenté")));
  }

  void changePhoto() async {
    final PickedFile image = await picker.getImage(source: ImageSource.gallery);
    final File robotImage =
        File(await _robotsRepository.setImage(state.robot, image.path));
    emit(state.copyWith(image: Image.file(robotImage)));
  }
}
