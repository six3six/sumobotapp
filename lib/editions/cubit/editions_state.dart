import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sumobot/repositories/editions/models/edition.dart';

class EditionsState extends Equatable {
  const EditionsState({
    this.editions = const <Edition>[],
  }) : assert(editions != null);

  final List<Edition> editions;

  EditionsState resetEditions(){
    return const EditionsState(editions: const <Edition>[]);
  }

  EditionsState addEdition(Edition edition){
    List<Edition> tmpEditions = List<Edition>();
    tmpEditions.addAll(editions);
    tmpEditions.add(edition);
    return EditionsState(editions: tmpEditions);
  }

  EditionsState addEditions(List<Edition> editions){
    List<Edition> tmpEditions = List<Edition>();
    tmpEditions.addAll(this.editions);
    tmpEditions.addAll(editions);
    return EditionsState(editions: tmpEditions);
  }

  @override
  List<Object> get props => [editions];
}
