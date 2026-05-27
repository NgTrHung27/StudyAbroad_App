import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/style/simplebutton.dart';
import 'package:study_abroad_cemc_mobile/components/functions/alert_form.dart';
import 'package:study_abroad_cemc_mobile/core/api/api_url.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/models/apply_scholar.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:http/http.dart' as http;

// Events
abstract class ApplyScholarEvent {}

class SendApplyScholarEvent extends ApplyScholarEvent {
  final String url;
  final String studentId;
  final String additional;

  SendApplyScholarEvent({
    required this.url,
    required this.studentId,
    required this.additional,
  });
}

// States
abstract class ApplyScholarState {}

class ApplyScholarInitial extends ApplyScholarState {}

class ApplyScholarLoading extends ApplyScholarState {}

class ApplyScholarSuccess extends ApplyScholarState {
  final ApplyScholarModel applyScholarModel;

  ApplyScholarSuccess(this.applyScholarModel);
}

class ApplyScholarFailure extends ApplyScholarState {
  final ApplyScholarModel? applyScholarModel;
  final String? error;

  ApplyScholarFailure({this.applyScholarModel, this.error});
}

class ApplyScholarError extends ApplyScholarState {
  final String error;

  ApplyScholarError(this.error);
}

// Bloc
class ApplyScholarBloc extends Bloc<ApplyScholarEvent, ApplyScholarState> {
  ApplyScholarBloc() : super(ApplyScholarInitial()) {
    on<SendApplyScholarEvent>(_onSendApplyScholar);
  }

  Future<void> _onSendApplyScholar(
      SendApplyScholarEvent event, Emitter<ApplyScholarState> emit) async {
    emit(ApplyScholarLoading());
    try {
      final response = await http.post(
        Uri.parse(event.url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'studentId': event.studentId,
          'additional': event.additional,
        }),
      );

      if (response.statusCode == 200) {
        emit(ApplyScholarSuccess(ApplyScholarModel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)))));
      } else {
        emit(ApplyScholarFailure(
          applyScholarModel: ApplyScholarModel.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes))),
        ));
      }
    } catch (e) {
      emit(ApplyScholarError(e.toString()));
    }
  }
}

class ApplyPage extends StatefulWidget {
  final String name;
  final String id;

  const ApplyPage({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  ApplyPageState createState() => ApplyPageState();
}

class ApplyPageState extends State<ApplyPage> {
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userAuth = context.watch<UserAuthProvider>().userAuthLogin;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => ApplyScholarBloc(),
      child: BlocBuilder<ApplyScholarBloc, ApplyScholarState>(
          builder: (context, state) {
        ApplyScholarModel? responseModel;
        Widget? backdropWidget;
        if (state is ApplyScholarLoading) {
          backdropWidget = BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (state is ApplyScholarSuccess) {
          backdropWidget = BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
              child: const Center(
                child: AlertDialogComponent(),
              ),
            ),
          );
        } else if (state is ApplyScholarFailure) {
          responseModel = state.applyScholarModel;
        } else if (state is ApplyScholarError) {
          return Center(child: Text(state.error));
        }

        return Stack(
          children: [
            Scaffold(
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextMonserats(scholarDescTextfieldKey.tr(),
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w700),
                          TextField(
                            style: GoogleFonts.getFont('Montserrat',
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.75),
                            controller: descriptionController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: scholarDescHintKey.tr(),
                              hintStyle: GoogleFonts.getFont('Montserrat',
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.75),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            maxLines: 8,
                            keyboardType: TextInputType.multiline,
                          ),
                          const SizedBox(height: 20),
                          if (responseModel != null) ...[
                            if (responseModel.error != null)
                              Column(
                                children: [
                                  TextMonserats(
                                    responseModel.error ?? '',
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                          ],
                          SimpleButton(
                            onPressed: () {
                              final url = ApiUrls.schoolScholarships(
                                userAuth?.student?.school.id ?? '',
                                widget.id,
                              );
                              context
                                  .read<ApplyScholarBloc>()
                                  .add(SendApplyScholarEvent(
                                    url: url,
                                    studentId: userAuth?.student?.id ?? '',
                                    additional: descriptionController.text,
                                  ));
                            },
                            child: TextMonserats(scholarDescSubmitKey.tr(),
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top +
                              screenHeight * 0.005,
                          left: screenWidth * 0.04),
                      child: const BackButtonCircle(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top +
                              screenHeight * 0.1),
                      child: TextMonserats(widget.name,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            if (backdropWidget != null) backdropWidget,
          ],
        );
      }),
    );
  }
}
