import 'package:equatable/equatable.dart';
import 'package:sumobot/repositories/news/model/new.dart';

class NewsState extends Equatable {
  final List<New> news;
  final bool isLoading;

  NewsState({this.news = const <New>[], this.isLoading = false});

  NewsState copyWith({
    List<New> news,
    bool isLoading,
  }) {
    return NewsState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [news];
}
