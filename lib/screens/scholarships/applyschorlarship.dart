import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/Style/simplebutton.dart';
import 'package:kltn_mobile/components/functions/alert_form.dart';
import 'package:kltn_mobile/models/apply_scholar.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class ApplyScholarCubit extends Cubit<ApplyScholarState> {
  ApplyScholarCubit() : super(ApplyScholarInitial());

  Future<void> sendApplyScholar(
      String url, String studentId, String additional) async {
    emit(ApplyScholarLoading());
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'studentId': studentId,
          'additional': additional,
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

class ApplyPage extends BasePage {
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

class ApplyPageState extends BasePageState<ApplyPage> {
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context);
    final scholarDescTextfield = localizations != null
        ? localizations.scholar_desc_textfield
        : "Default Text";
    final scholarDescHint = localizations != null
        ? localizations.scholar_desc_hint
        : "Default Text";
    final scholarDescSubmit = localizations != null
        ? localizations.scholar_desc_submit
        : "Default Text";
    return BlocProvider(
      create: (_) => ApplyScholarCubit(),
      child: BlocBuilder<ApplyScholarCubit, ApplyScholarState>(
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
                          TextMonserats(scholarDescTextfield,
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
                              hintText: scholarDescHint,
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
                              final url =
                                  'https://kltn-demo-deploy-admin.vercel.app/api/schools/${userAuth?.student.school.id}/scholarships/${widget.id}';
                              context
                                  .read<ApplyScholarCubit>()
                                  .sendApplyScholar(
                                    url,
                                    userAuth?.student.id ?? '',
                                    descriptionController.text,
                                  );
                            },
                            child: TextMonserats(scholarDescSubmit,
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
                              screenHeight * 0.009),
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
