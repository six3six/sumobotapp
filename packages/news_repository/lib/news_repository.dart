import 'model/article.dart';

abstract class NewsRepository {
  Stream<List<Article>> getNews();
}
