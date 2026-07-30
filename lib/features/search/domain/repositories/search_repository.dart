import 'package:dartz/dartz.dart';
import 'package:haditv/core/error/failure.dart';

abstract class SearchRepository {
  Future<Either<Failure, Map<String, dynamic>>> performSearch(String query);
  List<String> getRecentSearches();
  Future<void> saveRecentSearches(List<String> searches);
  Future<void> clearRecentSearches();
}
