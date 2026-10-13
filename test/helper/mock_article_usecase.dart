import 'package:bloc_test/bloc_test.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_categories_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_content_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:haditv/features/articles/presentation/cubit/article_detail/article_detail_cubit.dart';
import 'package:haditv/features/articles/presentation/cubit/article_detail/article_detail_state.dart';
import 'package:haditv/features/articles/presentation/cubit/article_list/article_list_cubit.dart';
import 'package:haditv/features/articles/presentation/cubit/article_list/article_list_state.dart';
import 'package:haditv/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:haditv/features/bookmark/domain/usecases/toggle_bookmark_usecase.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'package:haditv/features/bookmark/presentation/cubit/bookmark_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetArticlesUseCase extends Mock implements GetArticlesUseCase {}

class MockGetArticleCategoriesUseCase extends Mock
    implements GetArticleCategoriesUseCase {}

class MockGetArticleContentUseCase extends Mock
    implements GetArticleContentUseCase {}

class MockGetBookmarksUseCase extends Mock implements GetBookmarksUseCase {}

class MockToggleBookmarkUseCase extends Mock implements ToggleBookmarkUseCase {}

class MockArticleListCubit extends MockCubit<ArticleListState>
    implements ArticleListCubit {}

class MockArticleDetailCubit extends MockCubit<ArticleDetailState>
    implements ArticleDetailCubit {}

class MockBookmarkCubit extends MockCubit<BookmarkState>
    implements BookmarkCubit {}

