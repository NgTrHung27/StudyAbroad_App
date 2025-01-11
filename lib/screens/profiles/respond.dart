import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/Style/simplebutton.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/functions/alert_form.dart';
import 'package:kltn_mobile/components/functions/textfield_title.dart';
import 'package:kltn_mobile/models/response.dart';
import 'package:kltn_mobile/models/user_login.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class ResponseCubit extends Cubit<ResponseState> {
  ResponseCubit() : super(ResponseInitial());

  Future<void> sendResponse(String url, String message, List<String> images) async {
    emit(ResponseLoading());
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'message': message,
          'images': images,
        }),
      );

      if (response.statusCode == 200) {
        emit(ResponseSuccess(ResponseModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))));
      } else {
        emit(ResponseFailure(ResponseModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))));
      }
    } catch (e) {
      emit(ResponseError(e.toString()));
    }
  }
}

abstract class ResponseState {}

class ResponseInitial extends ResponseState {}

class ResponseLoading extends ResponseState {}

class ResponseSuccess extends ResponseState {
  final ResponseModel responseModel;

  ResponseSuccess(this.responseModel);
}

class ResponseFailure extends ResponseState {
  final ResponseModel responseModel;

  ResponseFailure(this.responseModel);
}

class ResponseError extends ResponseState {
  final String error;

  ResponseError(this.error);
}

class Respond extends BasePage {
  final String title;
  final String description;
  final String id;
  final List<StudentRequirementImage>? images;

  const Respond({
    super.key,
    required this.title,
    required this.description,
    required this.id,
    required this.images,
  });

  @override
  State<Respond> createState() => _RespondState();
}

class _RespondState extends BasePageState<Respond> {
  final TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<String> imageBase64List = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userAuth = context.watch<UserAuthProvider>().userAuthLogin;
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    for (var image in images) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      imageBase64List.add(base64Image);
    }
    setState(() {}); // Update the state to reflect the new image count
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final resq = localizations != null ? localizations.resq : 'Default Text';

    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.redButton,
        toolbarHeight: screenHeight * 0.09,
        title: Row(
          children: [
            BackButtonCircle(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: TextMonserats(
                  resq,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => ResponseCubit(),
        child: BlocBuilder<ResponseCubit, ResponseState>(
          builder: (context, state) {
            return Stack(
              children: [
                _buildResponseContent(context, state, isDarkMode, screenHeight),
                if (state is ResponseLoading)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.1),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponseContent(BuildContext context, ResponseState state, bool isDarkMode, double screenHeight) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    ResponseModel? responseModel;
    if (state is ResponseSuccess) {
      responseModel = state.responseModel;
    } else if (state is ResponseFailure) {
      responseModel = state.responseModel;
    } else if (state is ResponseError) {
      return Center(child: Text(state.error));
    }
    final localizations = AppLocalizations.of(context);
    final resq = localizations != null ? localizations.resq : 'Default Text';
    final resq1 = localizations != null ? localizations.resq_1 : 'Default Text';
    final resq2 = localizations != null ? localizations.resq_2 : 'Default Text';
    final resq3 = localizations != null ? localizations.resq_3 : 'Default Text';

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                color: isDarkMode ? AppColor.scafflodBgColorDark : Colors.white, //backscreen color
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        TextMonserats(
                          widget.title,
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        if (widget.images == null || widget.images!.isEmpty) Container(),
                        if (widget.images != null && widget.images!.isNotEmpty)
                          SizedBox(
                            height: screenHeight * 0.3,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: widget.images!.map((image) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.006),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        width: screenHeight * 0.35,
                                        height: screenHeight * 0.25,
                                        image.url ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextMonserats(
                            widget.description,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFieldTitle(
                          title: resq1,
                          controller: contentController,
                          hintText: resq2,
                          color: Colors.white,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        if (responseModel != null) ...[
                          if (responseModel.error != null)
                            TextMonserats(
                              responseModel.error!.issues.first.message,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                        ],
                        const SizedBox(height: 10),
                        SimpleButton(
                          backgroundColor: Colors.transparent,
                          borderColor: isDarkMode ? Colors.white : AppColor.redButton,
                          onPressed: _pickImages,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  size: 21,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                const SizedBox(width: 10),
                                TextMonserats(
                                  resq3,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                )
                              ]),
                        ),
                        const SizedBox(height: 10),
                        TextMonserats(
                          'Images uploaded: ${imageBase64List.length}',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        if (imageBase64List.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          SimpleButton(
                            backgroundColor: Colors.transparent,
                            borderColor: isDarkMode ? Colors.white : AppColor.redButton,
                            onPressed: () {
                              setState(() {
                                imageBase64List.clear();
                              });
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.clear,
                                    size: 21,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  const SizedBox(width: 10),
                                  TextMonserats(
                                    'Clear Images',
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  )
                                ]),
                          ),
                        ],
                        const SizedBox(height: 20),
                        SimpleButton(
                          backgroundColor: AppColor.redButton,
                          onPressed: () {
                            final url =
                                'https://kltn-demo-deploy-admin.vercel.app/api/accounts/students/${userAuth?.student.id}/requirements/${widget.id}';
                            context.read<ResponseCubit>().sendResponse(
                                  url,
                                  contentController.text,
                                  imageBase64List,
                                );
                          },
                          child: TextMonserats(
                            resq,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (responseModel != null && responseModel.message != null)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
              child: const Center(
                child: AlertDialogComponent(),
              ),
            ),
          ),
      ],
    );
  }
}
