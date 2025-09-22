import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/news_cubit_bloc/news_school_cubit.dart';
import 'package:kltn_mobile/blocs/news_cubit_bloc/news_school_state.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/screens/news/news_school_detail.dart';

class VerticalNewsListView extends StatefulWidget {
  const VerticalNewsListView({
    super.key,
    required this.schoolName,
  });
  final String schoolName;

  @override
  VerticalNewsListViewState createState() => VerticalNewsListViewState();
}

class VerticalNewsListViewState extends State<VerticalNewsListView> {
  @override
  void initState() {
    super.initState();
    context.read<NewsSchoolCubit>().getNewsByUserSchool(widget.schoolName);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    final localizations = AppLocalizations.of(context);
    final errorConn = localizations != null ? localizations.error_connection : "Defalut Text";
    return BlocBuilder<NewsSchoolCubit, NewsSchoolState>(
      builder: (context, state) {
        if (state is NewsSchoolLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsSchoolError) {
          print(state.message.toString());
          return Center(child: Text(errorConn));
        }
        if (state is NewsSchoolLoaded) {
          final newsSchoolList = state.newsSchoolList;
          if (newsSchoolList.isEmpty) {
            return const Center(child: Text('No news available'));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.newsSchoolList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsSchoolDetailPage(newsSchool: newsSchoolList[index]),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: bgColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2, // 40% of the box
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(newsSchoolList[index].cover),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3, // 60% of the box
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              TextMonserats(
                                newsSchoolList[index].title,
                                fontSize: 16,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        print('error state: $state');
        return Container();
      },
    );
  }
}
