import 'package:flutter/material.dart';
import 'package:haditv/core/error/api_call_handler.dart';
import 'package:haditv/core/network/api_client.dart';
import 'package:haditv/core/network/api_endpoints.dart';
import 'package:haditv/features/articles/data/models/article/article_model.dart';
import 'package:haditv/features/articles/data/models/article_category/article_category_model.dart';
import 'package:haditv/features/articles/data/models/article_detail/article_detail_model.dart';

class ArticleRemoteDataSource {
  final ApiClient apiClient;

  ArticleRemoteDataSource(this.apiClient);

  Future<List<ArticleCategoryModel>> getCategories() async {
    return safeApiCall<List<ArticleCategoryModel>>(() async {
      final response = await apiClient.dio.get(ApiEndpoints.articleGroup);
      return (response.data['articlegroup'] as List)
          .map((e) => ArticleCategoryModel.fromJson(e))
          .toList();
    });
  }

  Future<List<ArticleModel>> getArticles() async {
    return safeApiCall<List<ArticleModel>>(() async {
      final response = await apiClient.dio.get(ApiEndpoints.article);
      debugPrint(response.data.toString());

      return (response.data['articles'] as List)
          .map((e) => ArticleModel.fromJson(e))
          .toList();
    });
  }

  Future<ArticleDetailModel> getArticleContent(int id) async {
    return safeApiCall<ArticleDetailModel>(() async {
      final response = await apiClient.dio.post(
        ApiEndpoints.articleContent,
        queryParameters: {'id': id},
      );
      final data = response.data;

      return ArticleDetailModel.fromJson(data['post'][0]);
    });
  }
}
