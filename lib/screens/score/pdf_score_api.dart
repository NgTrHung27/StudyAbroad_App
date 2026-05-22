import 'dart:io';

import 'package:flutter/services.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';

class PdfScoreApi {
  static Future<File> generateScorePdf(List<Score> scores) async {
    final pdf = Document(
        theme: ThemeData.withFont(
            base: Font.ttf(
                await rootBundle.load('assets/fonts/Roboto-Regular.ttf'))));

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(scores[0]),
        buildScore(scores[0].subjects),
        Divider(),
      ],
    ));
    return PdfApi.saveDocument(name: 'my_score.pdf', pdf: pdf);
  }

  static Widget buildTitle(Score score) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hoc Ky: ${score.semester}"),
          Text('Nam Hoc: ${score.year}'),
        ],
      );
  static Widget buildScore(List<Subject> subjects) => Row(
        children: [
          Text('Mon Hoc: ${subjects.map((e) => e.name)}'),
          Text('Diem: ${subjects.map((e) => e.score.toString())}'),
        ],
      );
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    print(url);

    await OpenFile.open(url);
  }
}
