import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/news_cubit_bloc/news_cubit.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/models/news.dart';
import 'package:kltn_mobile/screens/news/news_detail.dart';

class NewsListViewShort extends StatefulWidget {
  const NewsListViewShort({super.key, required this.nullSchool});

  final dynamic nullSchool;
  @override
  NewsListViewShortState createState() => NewsListViewShortState();
}

class NewsListViewShortState extends State<NewsListViewShort> {
  List<NewsList> newsList = [];

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().getNewsList(widget.nullSchool);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final errorConn = localizations != null ? localizations.error_connection : "Defalut Text";
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsError) {
          return Center(child: Text(errorConn));
        }
        if (state is NewsSchoolLoaded) {
          return Center(child: Text(errorConn));
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
                      MaterialPageRoute(builder: (context) => NewsDetailPage(news: newsList[index])),
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
