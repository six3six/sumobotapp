import 'package:bloc/bloc.dart';

class SumobotObserver extends BlocObserver {
  @override
  void onChange(BlocBase cubit, Change change) {
    print('${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }
}
