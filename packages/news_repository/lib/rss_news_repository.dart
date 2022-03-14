import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

import 'model/article.dart';
import 'news_repository.dart';

class RssNewsRepository extends NewsRepository {
  final _targetUrl = "https://sumobot.esieespace.fr/feed/";

  Future<RssFeed> _getFeed() =>
      http.read(Uri.parse(_targetUrl)).then((xmlString) {
        return RssFeed.parse(xmlString);
      });

  @override
  Stream<List<Article>> getNews() async* {
    RssFeed feed = await _getFeed();
    yield feed.items
            ?.map<Article>((RssItem item) => Article.fromRss(item))
            .toList() ??
        [];
  }
}
