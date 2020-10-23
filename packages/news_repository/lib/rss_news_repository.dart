import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

import 'model/new.dart';
import 'news_repository.dart';

class RssNewsRepository extends NewsRepository {
  final _targetUrl = "https://sumobot.esieespace.fr/feed/";

  Future<RssFeed> _getFeed() => http.read(_targetUrl).then((xmlString) {
        return RssFeed.parse(xmlString);
      });

  @override
  Stream<List<New>> getNews() async* {
    RssFeed feed = await _getFeed();
    yield feed.items.map<New>((RssItem item) => New.fromRss(item)).toList();
  }
}
