import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haditv/config/theme/app_theme.dart';
import 'package:haditv/core/di/injection.dart';
import 'package:haditv/features/articles/domain/entities/article.dart';
import 'package:haditv/features/articles/domain/usecases/get_articles_usecase.dart';
import 'package:haditv/features/articles/domain/usecases/get_article_categories_usecase.dart';
import 'package:haditv/core/widgets/article_card.dart';
import 'package:haditv/core/widgets/empty_widget.dart';
import 'package:haditv/core/widgets/header.dart';
import 'package:haditv/core/utils/extension.dart';
import 'package:haditv/features/articles/presentation/widgets/articles_skeleton.dart';
import 'cubit/article_list/article_list_cubit.dart';
import 'cubit/article_list/article_list_state.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticleListCubit(
        getArticlesUseCase: getIt<GetArticlesUseCase>(),
        getCategoriesUseCase: getIt<GetArticleCategoriesUseCase>(),
      )..loadInit(),
      child: const Scaffold(body: ArticlesView()),
    );
  }
}

class ArticlesView extends StatelessWidget {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleListCubit, ArticleListState>(
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const MainHeader(pageName: 'Articles'),
            if (state is ArticleListLoading)
              const SliverToBoxAdapter(child: ArticlesSkeleton())
            else if (state is ArticleListError)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ArticleListCubit>().loadInit(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          context.tr('retry'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (state is ArticleListLoaded) ...[
              // Categories List (Horizontal)
              SliverToBoxAdapter(
                child: Container(
                  height: 52,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: state.categories.length + 1,
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final categoryId = isAll
                          ? 0
                          : state.categories[index - 1].id;
                      final categoryTitle = isAll
                          ? context.tr('all_articles')
                          : state.categories[index - 1].title;
                      final isSelected = state.selectedCategoryId == categoryId;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(categoryTitle),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryColor,
                          backgroundColor: context.cardBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : context.cardBorder,
                              width: 1,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : context.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              context.read<ArticleListCubit>().changeCategory(
                                categoryId,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Empty State
              if (state.filteredArticles.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyWidget(
                    icon: Icons.article_outlined,
                    title: context.tr('no_articles_found'),
                    subtitle: context.tr('no_articles_subtitle'),
                    actionLabel: context.tr('show_all_articles'),
                    onAction: () => context
                        .read<ArticleListCubit>()
                        .changeCategory(0),
                    iconColor: AppTheme.accentBlue,
                  ),
                )
              else
                // Articles List (Vertical)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final article = state.filteredArticles[index];
                      return _buildArticleItem(context, article);
                    }, childCount: state.filteredArticles.length),
                  ),
                ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildArticleItem(BuildContext context, Article article) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ArticleCard(
        article: article,
        onTap: () =>
            context.push('/articles/detail/${article.id}', extra: article),
      ),
    );
  }
}
