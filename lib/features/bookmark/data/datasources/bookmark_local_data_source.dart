import 'package:hive_flutter/hive_flutter.dart';
import 'package:haditv/core/service/storage/hive_initializer.dart';
import 'package:haditv/features/articles/data/models/article/article_model.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/videos/data/models/video/video_model.dart';
import 'package:haditv/features/videos/domain/entities/video.dart';

abstract class BookmarkLocalDataSource {
  List<Video> getBookmarkedVideos();
  Future<void> saveBookmarkedVideo(Video video);
  Future<void> removeBookmarkedVideo(int videoId);
  bool isVideoBookmarked(int videoId);

  List<Article> getBookmarkedArticles();
  Future<void> saveBookmarkedArticle(Article article);
  Future<void> removeBookmarkedArticle(int articleId);
  bool isArticleBookmarked(int articleId);

  Future<void> clearAllBookmarks();
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  Box get _box => Hive.box(HiveInitializer.bookmarksBoxName);

  static const String _videosKey = 'bookmarked_videos_map';
  static const String _articlesKey = 'bookmarked_articles_map';

  Map<String, dynamic> _getMap(String key) {
    final raw = _box.get(key, defaultValue: <String, dynamic>{});
    if (raw is Map) {
      return _deepMapCast(raw);
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _deepMapCast(Map dynamicMap) {
    final result = <String, dynamic>{};
    dynamicMap.forEach((key, value) {
      if (value is Map) {
        result[key.toString()] = _deepMapCast(value);
      } else if (value is List) {
        result[key.toString()] = value.map((item) {
          if (item is Map) {
            return _deepMapCast(item);
          }
          return item;
        }).toList();
      } else {
        result[key.toString()] = value;
      }
    });
    return result;
  }

  @override
  List<Video> getBookmarkedVideos() {
    final map = _getMap(_videosKey);
    final list = <Video>[];
    for (final entry in map.values) {
      try {
        if (entry is Map) {
          final jsonMap = _deepMapCast(entry);
          final model = VideoModel.fromJson(jsonMap);
          list.add(model.toEntity());
        }
      } catch (_) {}
    }
    return list;
  }

  @override
  Future<void> saveBookmarkedVideo(Video video) async {
    final map = _getMap(_videosKey);
    final videoMap = {
      'id': video.id,
      'category_id': video.categoryId,
      'title': video.title,
      'img': video.img,
      'date_time': video.dateTime,
      'description': video.description,
      'speaker_id': video.speakerId,
      'show_counter': video.showCounter,
      'video_url': video.videoUrl,
      'photo_url': video.photoUrl,
      'speaker_name': video.speakerName,
      'speaker': {
        'id': video.speaker.id,
        'lang': video.speaker.lang,
        'name': video.speaker.name,
        'email': video.speaker.email,
        'description': video.speaker.description,
        'slug': video.speaker.slug,
        'id_show': video.speaker.idShow,
        'photo_url': video.speaker.photoUrl ?? '',
      },
    };
    map[video.id.toString()] = videoMap;
    await _box.put(_videosKey, map);
  }

  @override
  Future<void> removeBookmarkedVideo(int videoId) async {
    final map = _getMap(_videosKey);
    map.remove(videoId.toString());
    await _box.put(_videosKey, map);
  }

  @override
  bool isVideoBookmarked(int videoId) {
    final map = _getMap(_videosKey);
    return map.containsKey(videoId.toString());
  }

  @override
  List<Article> getBookmarkedArticles() {
    final map = _getMap(_articlesKey);
    final list = <Article>[];
    for (final entry in map.values) {
      try {
        final jsonMap = Map<String, dynamic>.from(entry as Map);
        final model = ArticleModel.fromJson(jsonMap);
        list.add(model.toEntity());
      } catch (_) {}
    }
    return list;
  }

  @override
  Future<void> saveBookmarkedArticle(Article article) async {
    final map = _getMap(_articlesKey);
    final articleMap = {
      'id': article.id,
      'category_id': article.categoryId,
      'title': article.title,
      'photo_url': article.photoUrl,
      'readTime': article.readTime,
      'article_date': article.articleDate,
      'article_url': article.articleUrl,
    };
    map[article.id.toString()] = articleMap;
    await _box.put(_articlesKey, map);
  }

  @override
  Future<void> removeBookmarkedArticle(int articleId) async {
    final map = _getMap(_articlesKey);
    map.remove(articleId.toString());
    await _box.put(_articlesKey, map);
  }

  @override
  bool isArticleBookmarked(int articleId) {
    final map = _getMap(_articlesKey);
    return map.containsKey(articleId.toString());
  }

  @override
  Future<void> clearAllBookmarks() async {
    await _box.delete(_videosKey);
    await _box.delete(_articlesKey);
  }
}
