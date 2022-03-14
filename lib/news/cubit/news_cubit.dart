import 'package:bloc/bloc.dart';
import 'package:sumobot/news/cubit/news_state.dart';
import 'package:news_repository/news_repository.dart';
import 'package:news_repository/model/article.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(this._newsRepository) : super(NewsState()) {
    updateNews();
  }

  final NewsRepository _newsRepository;

  void updateNews() {
    emit(state.copyWith(isLoading: true));
    _newsRepository.getNews().listen((List<Article> news) {
      print(news);
      emit(state.copyWith(news: news, isLoading: false));
    });
  }
}
