import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_event.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_state.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_detail.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';

class NewsListViewShort extends StatefulWidget {
  const NewsListViewShort({super.key, required this.nullSchool});

  final dynamic nullSchool;
  @override
  NewsListViewShortState createState() => NewsListViewShortState();
}

class NewsListViewShortState extends State<NewsListViewShort> {
  List<NewsEntity> newsList = [];

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const LoadGeneralNewsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsError) {
          return Center(child: Text(errorConnectionKey.tr()));
        }
        if (state is NewsLoaded) {
          final newsList = state.newsList;
          if (newsList.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          return SizedBox(
            height: 300,
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(newsList[index].cover),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
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
                    ),
                  ),
                );
              },
            ),
          );
        }
        print('error state: $state');
        return Container();
      },
    );
  }
}
