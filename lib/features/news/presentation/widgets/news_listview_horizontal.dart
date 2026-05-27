import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_event.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_state.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_detail.dart';
import 'package:study_abroad_cemc_mobile/components/functions/empty_data.dart';
import 'package:study_abroad_cemc_mobile/components/functions/safe_network_image.dart';

class NewsListView extends StatefulWidget {
  const NewsListView({super.key, required this.nullSchool});

  final dynamic nullSchool;
  @override
  NewsListViewState createState() => NewsListViewState();
}

class NewsListViewState extends State<NewsListView> {
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const LoadGeneralNewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      // Chỉ rebuild khi nhận state loại general — tránh race condition
      buildWhen: (previous, current) {
        if (current is NewsInitial) return true;
        if (current is NewsLoading) return current.newsType == NewsType.general || current.newsType == NewsType.all;
        if (current is NewsLoaded) return current.newsType == NewsType.general || current.newsType == NewsType.all;
        if (current is NewsError) return current.newsType == NewsType.general || current.newsType == NewsType.all;
        return false;
      },
      builder: (context, state) {
        if (state is NewsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsError) {
          final isNetworkError = state.failure is NewsNetworkFailure;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isNetworkError ? Icons.wifi_off : Icons.error_outline,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        if (state is NewsLoaded) {
          final newsList = state.newsList;
          if (newsList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: EmptyDataWidget(
                text: 'Không có tin tức nào',
                icon: Icons.article_outlined,
              ),
            );
          }
          return SizedBox(
            height: 370,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailPage(news: newsList[index])),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        fit: StackFit.expand,
                      children: [
                        SafeNetworkImage(
                          url: newsList[index].cover,
                          fit: BoxFit.cover,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: TextMonserats(
                              newsList[index].title,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                );

              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
