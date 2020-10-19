import 'package:sumobot/repositories/news/model/new.dart';
import 'package:sumobot/repositories/news/news_repository.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

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
