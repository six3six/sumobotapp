

import 'model/new.dart';

abstract class NewsRepository {
  Stream<List<New>> getNews();
}
