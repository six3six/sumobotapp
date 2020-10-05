import 'package:bloc/bloc.dart';

class LobbyCubit extends Cubit<String> {
  LobbyCubit() : super("Test");

  /// Add 1 to the current state.
  void increment() => emit("+");

  /// Subtract 1 from the current state.
  void decrement() => emit("-");
}
