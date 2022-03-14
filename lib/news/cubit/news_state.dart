import 'package:equatable/equatable.dart';
import 'package:news_repository/model/article.dart';

class NewsState extends Equatable {
  final List<Article> news;
  final bool isLoading;

  NewsState({this.news = const <Article>[], this.isLoading = false});

  NewsState copyWith({
    List<Article>? news,
    bool? isLoading,
  }) {
    return NewsState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [news];
}
