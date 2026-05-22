import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_event.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_school_detail.dart';

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
    context.read<NewsBloc>().add(LoadSchoolNewsEvent(widget.schoolName));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state is NewsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsError) {
          print(state.message.toString());
          return Center(child: Text(errorConnectionKey.tr()));
        }
        if (state is NewsLoaded) {
          final newsSchoolList = state.newsList;
          if (newsSchoolList.isEmpty) {
            return const Center(child: Text('No news available'));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: newsSchoolList.length,
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
