import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/bloc/school_state.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/schools/presentation/pages/schools_list.dart';

typedef SchoolBloc = SchoolsBloc;

class CountrySchoolList extends StatefulWidget {
  final List<dynamic> schools; // Add this line
  const CountrySchoolList(
      {super.key, required this.schools}); // Modify this line

  @override
  State<CountrySchoolList> createState() => _CountrySchoolListState();
}

class _CountrySchoolListState extends State<CountrySchoolList> {
  List<String> uniqueCountries = [];

  @override
  void initState() {
    super.initState();
    // Extract unique country names
    final countrySet = <String>{};
    for (var school in widget.schools) {
      // Modify this line
      countrySet.add(school.country);
    }
    uniqueCountries = countrySet.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolBloc, SchoolState>(
      builder: (context, state) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: uniqueCountries.length, // Use uniqueCountries list here
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SchoolsListPage(country: uniqueCountries[index]),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage(ImageAssets.countryKorea),
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
                  child: const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: TextMonserats(
                        // newsList[index].title
                        'test',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
