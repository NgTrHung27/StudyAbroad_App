import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/schools/domain/entities/school_entity.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';

class ScholarDetailPage extends StatelessWidget {
  final SchoolScholarshipEntity scholar;
  const ScholarDetailPage({super.key, required this.scholar});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.5,
                child: Image.network(scholar.cover, fit: BoxFit.cover),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.5,
                  ),
                  child: IntrinsicHeight(
                    child: Container(
                      transform: Matrix4.translationValues(0.0, -120.0, 0.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextMonserats(scholar.name,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.06,
                                height: 1.3),
                            SizedBox(height: screenHeight * 0.02),
                            TextMonserats(scholar.description,
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.04,
                                height: 1.3),
                            // Thêm các widget khác tại đây để mở rộng nội dung
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: BackButtonCircle(onPressed: () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }
}
