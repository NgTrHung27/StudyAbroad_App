import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_event.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/bloc/news_state.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/failures/news_failures.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/features/news/presentation/pages/news_detail.dart';
import 'package:study_abroad_cemc_mobile/components/functions/empty_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.nullSchool});
  final dynamic nullSchool;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<NewsEntity> newsList = [];
  final TextEditingController _searchController = TextEditingController();

  final List<NewsEntity> _data = [];
  List<NewsEntity> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
    context.read<NewsBloc>().add(const LoadGeneralNewsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _filteredData = _data.where((newsItem) {
        return newsItem.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: textColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.001),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
            ),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: _searchController.clear,
                    icon: const Icon(CupertinoIcons.clear_circled_solid)),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: inputHintKey.tr(),
            hintStyle: const TextStyle(
              fontSize: 13,
            ),
            fillColor: bgColor,
            filled: true,
          ),
        ),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
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
                  TextMonserats(
                    state.message,
                    textAlign: TextAlign.center,
                    color: Colors.grey,
                  ),
                ],
              ),
            );
          }
          if (state is NewsLoaded) {
            Future.microtask(() {
              setState(() {
                _data.clear();
                _data.addAll(state.newsList);
                _performSearch();
              });
            });
            return buildNewsList(textColor, bgColor);
          }
          return Container();
        },
      ),
    );
  }

  Widget buildNewsList(Color textColor, Color bgColor) {
    return _filteredData.isEmpty
        ? _isNotFound(textColor, bgColor)
        : _isFound(textColor, bgColor);
  }

  Widget _isNotFound(Color textColor, Color bgColor) {
    return const Expanded(
      child: Center(
        child: EmptyDataWidget(
          text: 'Không có kết quả tìm kiếm',
          icon: Icons.search_off,
        ),
      ),
    );
  }

  Widget _isFound(Color textColor, Color bgColor) {
    return Column(
      children: [
        Expanded(
          child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02),
                  child: ListView.builder(
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NewsDetailPage(
                                        news: _filteredData[index])));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ListTile(
                                      title: Text(_filteredData[index].title,
                                          style: GoogleFonts.getFont(
                                            'Montserrat',
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ))),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      height: 100,
                                      _filteredData[index].cover.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                              ],
                            ),
                          ))))),
        ),
      ],
    );
  }
}
