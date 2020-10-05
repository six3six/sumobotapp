import 'dart:async';

import './models/edition.dart';

abstract class EditionsRepository {
  Stream<List<Edition>> editions();

  Stream<Edition> edition(String uid);
}
