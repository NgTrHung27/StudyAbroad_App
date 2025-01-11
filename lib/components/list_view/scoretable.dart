import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:provider/provider.dart';

import '../../screens/Authentication/auth_data_notify.dart';

class ScoreTable extends BasePage {
  final String semester;
  final String year;
  const ScoreTable({super.key, required this.semester, required this.year});

  @override
  ScoreTableState createState() => ScoreTableState();
}

class ScoreTableState extends BasePageState<ScoreTable> {
  @override
  Widget build(BuildContext context) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    final screenWidth = MediaQuery.of(context).size.width;

    final localizations = AppLocalizations.of(context);

    // Lọc điểm theo semester và year
    final filteredScores = userAuth?.student.program?.scores?.where((score) {
      return score.semester == widget.semester && score.year == widget.year;
    }).toList();

    final subjectLabel = localizations?.scr_subject ?? "Default Text";
    final scoreLabel = localizations?.scr_score ?? "Default Text";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 3,
            spreadRadius: 3,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DataTable(
          dividerThickness: 0,
          columnSpacing: screenWidth * 0.2,
          dataRowMinHeight: screenWidth * 0.13,
          dataRowMaxHeight: screenWidth * 0.18,
          headingRowColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return AppColor.redButton; // Màu nền tiêu đề bảng
            },
          ),
          headingTextStyle: const TextStyle(
            color: Colors.white, // Màu chữ tiêu đề bảng
            fontWeight: FontWeight.bold,
          ),
          columns: [
            DataColumn(
              label: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: TextMonserats(
                  subjectLabel,
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
            DataColumn(
              label: TextMonserats(
                scoreLabel,
                color: Colors.white,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
          rows: filteredScores?.asMap().entries.expand((entry) {
                int index = entry.key;
                final subjectScore = entry.value;

                // Duyệt qua từng môn học trong danh sách `subjects`
                return subjectScore.subjects.map((subject) {
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        return index.isEven ? Colors.white : const Color(0xffFFE9E4); // Màu xen kẽ các hàng
                      },
                    ),
                    cells: [
                      DataCell(Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.05),
                        child: TextMonserats(
                          subject.name, // Tên môn học
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          height: 1.3,
                          textAlign: TextAlign.start,
                        ),
                      )),
                      DataCell(SizedBox(
                        width: screenWidth * 0.4,
                        child: TextMonserats(
                          subject.score.toString(), // Điểm môn học
                          fontSize: screenWidth * 0.035,
                          color: Colors.black,
                        ),
                      )),
                    ],
                  );
                }).toList();
              }).toList() ??
              [],
        ),
      ),
    );
  }
}
