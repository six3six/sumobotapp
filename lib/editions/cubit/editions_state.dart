import 'package:editions_repository/models/edition.dart';
import 'package:equatable/equatable.dart';

class EditionsState extends Equatable {
  const EditionsState({
    this.editions = const <Edition>[],
  });

  final List<Edition> editions;

  EditionsState resetEditions() {
    return const EditionsState(editions: const <Edition>[]);
  }

  EditionsState addEdition(Edition edition) {
    List<Edition> tmpEditions = const [];
    tmpEditions.addAll(editions);
    tmpEditions.add(edition);
    return EditionsState(editions: tmpEditions);
  }

  EditionsState addEditions(List<Edition> editions) {
    List<Edition> tmpEditions = const [];
    tmpEditions.addAll(this.editions);
    tmpEditions.addAll(editions);
    return EditionsState(editions: tmpEditions);
  }

  @override
  List<Object> get props => [editions];
}
