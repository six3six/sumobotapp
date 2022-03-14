import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:robots_repository/firestore_robots_repository.dart';
import 'package:robots_repository/firestore_robots_step_repository.dart';
import 'package:robots_repository/models/robot.dart';
import 'package:robots_repository/models/step.dart' as Step;

import 'package:sumobot/robot/cubit/robot_state.dart';

class RobotCubit extends Cubit<RobotState> {
  RobotCubit(String robot, this.edition, this._robotsRepository)
      : super(RobotState(
          robot: Robot.empty,
          image: const Icon(FontAwesomeIcons.question),
        )) {
    _robotsRepository.getRobotByUid(robot).listen((Robot robot) async {
      emit(state.copyWith(robot: robot));

      _robotsStepsRepository = FirestoreRobotsStepsRepository(edition);
      if (_robotsStepsStreamSub != null) await _robotsStepsStreamSub.cancel();

      _robotsStepsStreamSub =
          _robotsStepsRepository.step(robot).listen((Step.Step step) {
        emit(state.copyWith(step: step));
        print("step " + step.toString());
      });

      _robotsRepository.getImage(robot).then((value) {
        final File image = File(value);
        if (image.existsSync())
          emit(state.copyWith(
              image:
                  Image.memory(Uint8List.fromList(image.readAsBytesSync()))));
        else
          emit(state.copyWith(image: const Icon(FontAwesomeIcons.question)));
      });
    });
  }

  late FirestoreRobotsStepsRepository _robotsStepsRepository;
  late StreamSubscription _robotsStepsStreamSub;
  final FirestoreRobotsRepository _robotsRepository;
  final String edition;

  final picker = ImagePicker();

  void delete(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Etes-vous sûr ?"),
        actions: [
          OutlineButton(
              onPressed: () => Navigator.of(context).pop(), child: Text("Non")),
          FlatButton(
              onPressed: () {
                _robotsRepository.deleteRobot(state.robot);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Oui"))
        ],
      ),
    );
  }

  void changePhoto() async {
    try {
      final PickedFile? image =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
      if (image == null) return;
      final File robotImage =
          File(await _robotsRepository.setImage(state.robot, image.path));
      emit(state.copyWith(image: Image.file(robotImage)));
      imageCache?.clear();
    } catch (e) {
      return;
    }
  }
}
