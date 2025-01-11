// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kltn_mobile/blocs/auth_cubit_bloc/auth_cubit.dart';
import 'package:kltn_mobile/blocs/auth_cubit_bloc/auth_state.dart';
import 'package:kltn_mobile/blocs/lang_cubit/language_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/functions/convert_imagetostring.dart';
import 'package:kltn_mobile/components/functions/dropdown.dart';
import 'package:kltn_mobile/components/functions/radio.dart';
import 'package:kltn_mobile/components/functions/text_field.dart';
import 'package:kltn_mobile/components/style/backbutton.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/components/style/simplebutton.dart';
import 'package:kltn_mobile/components/style/textspan.dart';
import 'package:kltn_mobile/models/country.dart';
import 'package:kltn_mobile/models/enum.dart';
import 'package:kltn_mobile/models/schools.dart';
import 'package:kltn_mobile/screens/authentication/login_page.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class RegisterPage extends BasePage {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

//Declare Date Input
class _RegisterPageState extends BasePageState<RegisterPage> {
  //Declare Language
  String register_1 = '';
  String register_2 = '';
  String register_3 = '';
  String register_4 = '';
  String register_5 = '';
  String register_6 = '';
  String register_login_signin = '';
  String register_email = '';
  String register_pass = '';
  String register_7 = '';
  String register_8 = '';
  String register_9 = '';
  String register_10 = '';
  String register_11 = '';
  String register_12 = '';
  String register_13 = '';
  String register_14 = '';
  String register_15 = '';
  String register_16 = '';
  String register_17 = '';
  String register_18 = '';
  String register_18_1 = '';
  String register_19 = '';
  String register_20 = '';
  String register_21 = '';
  String register_22 = '';
  String register_23 = '';
  String register_24 = '';
  String register_25 = '';
  String register_26 = '';
  String register_signup = '';
  //Declare API School
  List<Schools> lstschools = [];
  List<Country> lstCountry = [];
  List<String> lstCountrySchool = [];
  String? errorEmailMessage,
      errorNameMessage,
      errorPasswordMessage,
      errorConfrimPasswordMessage,
      errorIDCardNumberMessage,
      errorDateMessage,
      errorPhoneMessage,
      errorCityMessage,
      errorDistrictMessage,
      errorWardMessage,
      errorAddressMessage,
      errorGenderMessage,
      errorDegreeMessage,
      errorGradeTypeMessage,
      errorGradeMessage,
      errorCertificateTypeMessage,
      errorMessage;
  //Declare
  String email = '', name = '', password = '', confirmpassword = '', phone = '', idCardNumber = '', dob = '';
  Schools? selectedSchoolObject;
  String? selectedSchool, selectedCountry, selectedProgram, selectedCity, selectedDistrict, selectedWard;
  String address = '';
  Gender? valueGender;
  DegreeType? valueDegree;
  GradeType? radioGradeTypeValue; // 0: GPA, 1: CGPA
  double gradeScore = 0.0;
  CertificateType? selectedCertificateType;
  String certificateImg = '';
  bool isLoading = false;

  //End of Declare
  //-----------------------------------------------------------------------------------
  //Declare Controller
  final usermailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final idCardNumberController = TextEditingController();
  final dateController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = DropdownButtonFormField;
  final cityController = DropdownButtonFormField;
  final districtController = DropdownButtonFormField;
  final wardController = DropdownButtonFormField;
  final addressController = TextEditingController();
  final schoolController = DropdownButtonFormField;
  final programController = DropdownButtonFormField;
  final degreeController = DropdownButtonFormField;
  final certificateController = DropdownButtonFormField;
  final gradeTypecontroller = DropdownButtonFormField;
  final gradeController = TextEditingController();
  final certificateTypeController = RadioListTile;
  TextEditingController imageController = TextEditingController();
  int currentStep = 0;

  //--------------------------------------------------------------------------------------------------

  void userRegister() async {
    setState(() {
      isLoading = true;
    });
    String email = usermailController.text.trim(),
        name = usernameController.text.trim(),
        password = passwordController.text.trim(),
        confirmpassword = confirmpasswordController.text.trim(),
        idCardNumber = idCardNumberController.text.trim(),
        phone = phoneController.text.trim(),
        address = addressController.text.trim(),
        certificateImg = imageController.text.toString();
// Kiểm tra trường ngày tháng có rỗng không
    if (dateController.text.trim().isEmpty) {
      // Hiển thị thông báo lỗi hoặc xử lý lỗi tại đây
      setState(() {
        isLoading = false;
      });
      return; // Ngừng xử lý nếu trường ngày tháng rỗng
    }
    DateTime dob;
    try {
      dob = DateFormat('dd/MM/yyyy').parse(dateController.text.trim());
    } catch (e) {
      // Xử lý lỗi phân tích ngày tháng tại đây
      setState(() {
        isLoading = false;
      });
      return; // Ngừng xử lý nếu có lỗi khi phân tích ngày tháng
    }
    double gradeScore;
    try {
      gradeScore = double.parse(gradeController.text.trim());
    } catch (e) {
      // Xử lý lỗi chuyển đổi số thực tại đây
      setState(() {
        isLoading = false;
      });
      return; // Ngừng xử lý nếu có lỗi khi chuyển đổi điểm số
    }
    String gradeScoreString = gradeScore.toString();
    var items = {
      'School': selectedSchool,
      'Country': selectedCountry,
      'Program': selectedProgram,
      'City': selectedCity,
      'District': selectedDistrict,
      'Ward': selectedWard,
      'valueGender': valueGender,
      'valueDegree': valueDegree,
      'radioGradeTypeValue': radioGradeTypeValue,
      'selectedCertificateType': selectedCertificateType,
    };
    items.forEach((key, value) {
      if (value == null) {
        print('$key is null');
      }
    });
    //Call API from APIService

    context.read<AuthCubit>().register(
        email,
        name,
        password,
        confirmpassword,
        idCardNumber,
        dob,
        phone,
        selectedSchool,
        selectedCountry,
        selectedProgram,
        selectedCity,
        selectedDistrict,
        selectedWard,
        address,
        valueGender,
        valueDegree,
        radioGradeTypeValue,
        gradeScoreString,
        selectedCertificateType,
        certificateImg);
  }

  //Declare intial state value for selectedSchool ,program, city, district, ward
  void schoolChange(Schools? school) {
    setState(() {
      if (school != null) {
        selectedSchoolObject = school;
        selectedSchool = school.name;
      }
    });
  }

  void programChange(SchoolProgram? program) {
    setState(() {
      if (program != null) {
        selectedProgram = program.name;
      }
    });
  }

  void cityChange(Country? city) {
    setState(() {
      if (city != null) {
        selectedCity = city.name;
      }
    });
  }

  void districtChange(District? district) {
    setState(() {
      if (district != null) {
        selectedDistrict = district.name;
      }
    });
  }

  void wardChange(Ward? ward) {
    setState(() {
      if (ward != null) {
        selectedWard = ward.name;
      }
    });
  }

  void radioValueChanged(GradeType? gradeType) {
    setState(() {
      if (gradeType != null) {
        radioGradeTypeValue = gradeType;
      }
    });
  }

  void genderValueChanged(Gender? gender) {
    setState(() {
      if (gender != null) {
        valueGender = gender;
      }
    });
  }

  void degreeValueChanged(DegreeType? degreeType) {
    setState(() {
      if (degreeType != null) {
        valueDegree = degreeType;
      }
    });
  }

  void certificateTypeValueChanged(CertificateType? certificateType) {
    setState(() {
      if (certificateType != null) {
        selectedCertificateType = certificateType;
      }
    });
  }

  Future<void> imageValueChanged(String? certiImg) async {
    setState(() {
      if (certiImg != null) {
        certificateImg = certiImg;
      }
    });
  }
  //End of Intial Method
  //-----------------------------------------------------------------------------------

  //Image Picker Method
  Future<String?> getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      String? base64Image = await convertImageToBase64(pickedImage.path);
      if (base64Image != null) {
        setState(() {
          certificateImg = base64Image;
          imageController.text = certificateImg;
        });
        return base64Image;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  String getGenderLabel(BuildContext context, Gender gender) {
    switch (gender) {
      case Gender.Male:
        return Intl.message(
          'Male',
          name: 'male',
          locale: Localizations.localeOf(context).languageCode,
        );
      case Gender.Female:
        return Intl.message(
          'Female',
          name: 'female',
          locale: Localizations.localeOf(context).languageCode,
        );
    }
  }

  //Date
  Future<void> openDatePicker(BuildContext context) async {
    BottomPicker.date(
      pickerTitle: Text(
        'Date of Birth',
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      pickerTextStyle: GoogleFonts.montserrat(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      dateOrder: DatePickerDateOrder.dmy,
      bottomPickerTheme: BottomPickerTheme.blue,
      initialDateTime: DateTime(2000, 01, 01),
      maxDateTime: DateTime(2010),
      minDateTime: DateTime(1960),
      onChange: (value) {
        setState(() {
          dateController.text = DateFormat('dd/MM/yyyy').format(value);
        });
      },
      onSubmit: (value) {
        dateController.text = DateFormat('dd/MM/yyyy').format(value);
        if (value.isAfter(DateTime(DateTime.now().year - 17))) {
          context.read<AuthCubit>().checkDob(value);
        } else {
          setState(() {
            errorDateMessage = null;
          });
        }
      },
    ).show(context);
  }

  //End of Image Picker Method
//-----------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getSchoolsAndCountries();
    context.read<AuthCubit>().getCity();
  }

//-----------------------------------------------------------------------------------
//Stepper Method
  continueStep() {
    final isLastStep = currentStep ==
        getSteps(
                    register_1,
                    register_2,
                    register_3,
                    register_4,
                    register_5,
                    register_6,
                    register_login_signin,
                    register_email,
                    register_pass,
                    register_7,
                    register_8,
                    register_9,
                    register_10,
                    register_11,
                    register_12,
                    register_13,
                    register_14,
                    register_15,
                    register_16,
                    register_17,
                    register_18,
                    register_18_1,
                    register_19,
                    register_20,
                    register_21,
                    register_22,
                    register_23,
                    register_24,
                    register_25,
                    register_26,
                    register_signup)
                .length -
            1;
    if (isLastStep) {
    } else {
      setState(() {
        currentStep += 1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlsBuilder(context, details, {String? register_25, register_26}) {
    return BlocBuilder<LanguageBloc, Locale>(
      builder: (context, state) {
        String currentLanguageCode = state.languageCode;

        // Xác định các chuỗi ký tự theo ngôn ngữ
        String backText;
        String continueText;
        String signUpText;

        if (currentLanguageCode == 'vi') {
          backText = 'Trở lại';
          continueText = 'Tiếp tục';
          signUpText = 'Đăng ký';
        } else if (currentLanguageCode == 'ko') {
          backText = '뒤로';
          continueText = '계속';
          signUpText = '가입';
        } else {
          backText = 'Back';
          continueText = 'Next';
          signUpText = 'Sign Up';
        }

        return Container(
          child: currentStep == 2 // Kiểm tra nếu đang ở bước thứ 3
              ? Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SimpleButton(
                        backgroundColor: Colors.transparent,
                        borderColor: AppColor.redButton,
                        onPressed: details.onStepCancel,
                        child: TextMonserats(
                          backText,
                          color: AppColor.redButton,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: SimpleButton(
                          onPressed: () {
                            userRegister();
                          },
                          child: TextMonserats(
                            signUpText,
                            color: Colors.white,
                          ),
                        )),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: SimpleButton(
                          backgroundColor: Colors.transparent,
                          borderColor: AppColor.redButton,
                          onPressed: details.onStepCancel,
                          child: TextMonserats(
                            backText,
                            color: AppColor.redButton,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 120),
                    Expanded(
                      child: SimpleButton(
                        onPressed: details.onStepContinue,
                        child: TextMonserats(
                          continueText,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

// List Steps
  List<Step> getSteps(
          register1,
          register2,
          register3,
          register4,
          register5,
          register6,
          register_login_signin,
          register_email,
          register_pass,
          register_7,
          register_8,
          register_9,
          register_10,
          register_11,
          register_12,
          register_13,
          register_14,
          register_15,
          register_16,
          register_17,
          register_18,
          register_18_1,
          register_19,
          register_20,
          register_21,
          register_22,
          register_23,
          register_24,
          register_25,
          register_26,
          registerSignup) =>
      [
        //Step 1 - Account
        Step(
          title: const SizedBox.shrink(),
          isActive: currentStep != 1 && currentStep != 2,
          label: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0), // Điều chỉnh khoảng cách giữa các số 1, 2, 3 ở đây
            child: TextMonserats(register3),
          ),
          content: Column(
            children: [
              MyTextField(
                controller: usermailController,
                hintText: register_email,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                prefixIcon: Icons.email,
                errorText: errorEmailMessage,
                onChanged: (value) {
                  // Lưu giá trị email mới được nhập
                  email = value;
                  context.read<AuthCubit>().checkEmail(email);
                  if (email.isEmpty) {
                    setState(() {
                      errorEmailMessage;
                    });
                  } else {
                    setState(() {
                      errorEmailMessage = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 3),
              MyTextField(
                controller: usernameController,
                hintText: register_7,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                prefixIcon: Icons.person,
                errorText: errorNameMessage,
                onChanged: (value) {
                  // Lưu giá trị email mới được nhập
                  name = value;
                  context.read<AuthCubit>().checkName(name);
                  if (name.isEmpty) {
                    setState(() {
                      errorNameMessage;
                    });
                  } else {
                    setState(() {
                      errorMessage = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 3),
              MyTextField(
                controller: passwordController,
                hintText: register_pass,
                obscureText: true,
                prefixIcon: Icons.lock,
                errorText: errorPasswordMessage,
                onChanged: (value) {
                  // Lưu giá trị email mới được nhập
                  password = value;
                  context.read<AuthCubit>().checkPassword(password);
                  if (password.isEmpty) {
                    setState(() {
                      errorPasswordMessage;
                    });
                  } else {
                    setState(() {
                      errorPasswordMessage = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 3),
              MyTextField(
                controller: confirmpasswordController,
                hintText: register_8,
                obscureText: true,
                prefixIcon: Icons.lock_reset,
                errorText: errorConfrimPasswordMessage,
                onChanged: (value) {
                  // Lưu giá trị email mới được nhập
                  confirmpassword = value;
                  context.read<AuthCubit>().checkConfrimPassword(password, confirmpassword);
                  if (confirmpassword.isEmpty) {
                    setState(() {
                      errorConfrimPasswordMessage;
                    });
                  } else {
                    setState(() {
                      errorConfrimPasswordMessage = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 3),
              MyTextField(
                controller: idCardNumberController,
                hintText: register_9,
                obscureText: false,
                prefixIcon: Icons.how_to_reg,
                errorText: errorIDCardNumberMessage,
                onChanged: (value) {
                  // Lưu giá trị email mới được nhập
                  idCardNumber = value;
                  context.read<AuthCubit>().checkIDCardNumber(idCardNumber);
                  if (idCardNumber.isEmpty) {
                    setState(() {
                      errorIDCardNumberMessage;
                    });
                  } else {
                    setState(() {
                      errorIDCardNumberMessage = null;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        //---------------------------------------------------------------------------------------------------------
        //Step 2 - Profile
        Step(
          title: const SizedBox.shrink(),
          isActive: currentStep != 0 && currentStep != 2,
          label: TextMonserats(register4),
          content: Column(
            children: [
              //DOB
              SizedBox(
                  width: double.infinity,
                  height: 73,
                  child: GestureDetector(
                    onTap: () {
                      openDatePicker(context);
                    },
                    child: AbsorbPointer(
                      child: MyTextField(
                        controller: dateController,
                        hintText: register_10,
                        obscureText: false,
                        prefixIcon: Icons.date_range,
                        errorText: errorDateMessage,
                        onChanged: (context) {},
                      ),
                    ),
                  )),
              //Gender - Phone number
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 73,
                      child: DropdownCustom<Gender>(
                        icon: Icons.wc,
                        hintText: register_11,
                        items: Gender.values,
                        selectedItem: valueGender,
                        errorText: errorGenderMessage,
                        onChanged: (Gender? newValueGender) {
                          if (newValueGender != null) {
                            setState(() {
                              errorGenderMessage;
                            });
                          } else {
                            setState(() {
                              errorGenderMessage = null;
                            });
                          }
                          setState(() {
                            genderValueChanged(newValueGender);
                          });
                        },
                        itemLabel: (Gender gender) => getGenderLabel(context, gender),
                        isExpanded: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15), // Khoảng cách giữa hai trường
                  Expanded(
                    child: MyTextField(
                      keyboardType: TextInputType.number,
                      controller: phoneController, // Thêm controller cho trường số điện thoại
                      hintText: register_12,
                      obscureText: false,
                      prefixIcon: Icons.phone,
                      errorText: errorPhoneMessage,
                      onChanged: (value) {
                        // Save phone value
                        phone = value;
                        if (phone.isEmpty) {
                          setState(() {
                            errorPhoneMessage;
                          });
                        } else {
                          setState(() {
                            errorPhoneMessage = null;
                          });
                        }
                        context.read<AuthCubit>().checkPhoneNumber(phone);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              //Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextMonserats(register_13),
                ],
              ),
              //City
              const SizedBox(height: 12),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadedCityState) {
                    lstCountry = state.country;
                  }
                  return DropdownCustom<Country>(
                    icon: Icons.location_city,
                    items: lstCountry,
                    selectedItem:
                        selectedCity == null ? null : lstCountry.firstWhere((element) => element.name == selectedCity),
                    onChanged: (Country? newValueCountry) {
                      if (newValueCountry != null) {
                        cityChange(newValueCountry);
                        selectedDistrict = null;
                        selectedWard = null;
                      }
                    },
                    itemLabel: (Country country) => country.name,
                    hintText: register_14,
                    isExpanded: false,
                  );
                },
              ),
              //District - Ward
              const SizedBox(height: 15),
              Row(children: [
                Expanded(child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoadedCityState) {
                      lstCountry = state.country;
                    }
                    return DropdownCustom<District>(
                      icon: Icons.map,
                      items: selectedCity == null
                          ? []
                          : lstCountry.firstWhere((element) => element.name == selectedCity).districts,
                      selectedItem: selectedDistrict == null
                          ? null
                          : lstCountry
                              .firstWhere((element) => element.name == selectedCity)
                              .districts
                              .firstWhere((element) => element.name == selectedDistrict),
                      onChanged: (District? newValueDistrict) {
                        setState(() {
                          districtChange(newValueDistrict);
                          selectedWard = null;
                        });
                      },
                      itemLabel: (District district) => district.name,
                      hintText: register_15,
                      isExpanded: true,
                    );
                  },
                )),
                const SizedBox(width: 15),
                Expanded(child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoadedCityState) {
                      lstCountry = state.country;
                    }
                    return DropdownCustom<Ward>(
                      icon: Icons.location_on,
                      items: selectedDistrict == null
                          ? []
                          : lstCountry
                              .firstWhere((element) => element.name == selectedCity)
                              .districts
                              .firstWhere((element) => element.name == selectedDistrict)
                              .wards,
                      selectedItem: selectedWard == null
                          ? null
                          : lstCountry
                              .firstWhere((element) => element.name == selectedCity)
                              .districts
                              .firstWhere((element) => element.name == selectedDistrict)
                              .wards
                              .firstWhere((element) => element.name == selectedWard),
                      onChanged: (Ward? newValueWard) {
                        setState(() {
                          wardChange(newValueWard);
                        });
                      },
                      itemLabel: (Ward ward) => ward.name,
                      hintText: register_16,
                      isExpanded: true,
                    );
                  },
                )),
              ]),
              const SizedBox(height: 15),
              MyTextField(
                controller: addressController,
                hintText: register_17,
                obscureText: false,
                prefixIcon: Icons.home,
                onChanged: (value) {
                  // Lưu giá trị email mới được nhập
                  email = value;
                },
              ),
            ],
          ),
        ),
        //---------------------------------------------------------------------------------------------------------
        //Step 3 - Education
        Step(
          title: const SizedBox.shrink(),
          isActive: currentStep != 0 && currentStep != 1,
          label: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0), // Điều chỉnh khoảng cách giữa các số 1, 2, 3 ở đây
            child: TextMonserats(register5),
          ),
          content: Column(
            children: [
              //Country
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoadedState) {
                          lstCountrySchool = state.countries;
                        }
                        return DropdownCustom<String>(
                          icon: Icons.location_city,
                          items: lstCountrySchool,
                          selectedItem: selectedCountry == null
                              ? null
                              : lstCountrySchool.firstWhere((element) => element == selectedCountry),
                          onChanged: (String? newValueCountry) {
                            setState(() {
                              selectedCountry = newValueCountry;
                              if (context.read<AuthCubit>().state is AuthLoadedState) {
                                (context.read<AuthCubit>().state as AuthLoadedState)
                                    .schools
                                    .where((schools) => schools.country == selectedCountry)
                                    .toList();
                              }
                            });
                          },
                          itemLabel: (String country) => country,
                          hintText: register_18_1,
                          isExpanded: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoadedState) {
                        lstschools = state.schools;
                      }
                      return DropdownCustom<Schools>(
                        icon: Icons.school,
                        items: lstschools,
                        selectedItem: selectedSchool == null
                            ? null
                            : lstschools.firstWhere((element) => element.name == selectedSchool),
                        onChanged: (Schools? newValueSchool) {
                          setState(() {
                            schoolChange(newValueSchool);
                            selectedProgram = null;
                          });
                        },
                        itemLabel: (Schools school) => school.name,
                        hintText: register_18,
                        isExpanded: true,
                      );
                    },
                  )),
                ],
              ),
              const SizedBox(height: 15),
              // Major - Degree
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoadedState) {
                          lstschools = state.schools;
                        }
                        return DropdownCustom<SchoolProgram>(
                          icon: Icons.history_edu,
                          items: selectedSchool == null ? [] : selectedSchoolObject!.programs ?? [],
                          selectedItem: selectedProgram == null
                              ? null
                              : selectedSchoolObject!.programs
                                  ?.firstWhere((element) => element.name == selectedProgram),
                          onChanged: (SchoolProgram? newValueProgram) {
                            setState(() {
                              programChange(newValueProgram);
                            });
                          },
                          itemLabel: (SchoolProgram program) => program.name,
                          hintText: register_19,
                          isExpanded: true,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownCustom<DegreeType>(
                      icon: Icons.hotel_class,
                      items: DegreeType.values,
                      selectedItem: valueDegree,
                      onChanged: (DegreeType? newValueDegree) {
                        setState(() {
                          degreeValueChanged(newValueDegree);
                        });
                      },
                      itemLabel: (DegreeType degreeType) => degreeType.toString().split('.').last,
                      hintText: register_20,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              //Certificate
              DropdownCustom<CertificateType>(
                icon: Icons.bookmark_add,
                items: CertificateType.values,
                onChanged: (CertificateType? newValueCertificateType) {
                  setState(() {
                    certificateTypeValueChanged(newValueCertificateType);
                  });
                },
                selectedItem: selectedCertificateType,
                itemLabel: (CertificateType certificateType) => certificateType.toString().split('.').last,
                hintText: register_21,
                isExpanded: false,
              ),

              // Upload Certificate
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 37,
                child: SimpleButton(
                  backgroundColor: Colors.transparent,
                  borderColor: AppColor.redButton,
                  onPressed: () {
                    Future<String?> imageValueChanged() async {
                      String? certiImg = await getImage();
                      if (certiImg != null) {
                      } else {}
                      return null;
                    }

                    imageValueChanged();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.upload_file,
                        size: 21,
                      ),
                      const SizedBox(width: 10),
                      TextMonserats(register_22)
                    ],
                  ),
                ),
              ),
              //Overall Score
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextMonserats(register_23),
                ],
              ),
              //GPA - CGPA
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomRadio<GradeType>(
                    value: GradeType.GPA,
                    groupValue: radioGradeTypeValue,
                    onChanged: (GradeType? newGradeTypeValue) {
                      radioValueChanged(newGradeTypeValue);
                    },
                    title: 'GPA (?/4.0)',
                  ),
                  CustomRadio<GradeType>(
                    value: GradeType.CGPA,
                    groupValue: radioGradeTypeValue,
                    onChanged: (GradeType? newGradeTypeValue) {
                      radioValueChanged(newGradeTypeValue);
                    },
                    title: 'GGPA (?/10.0)',
                  ),
                ],
              ),
              //Grade Score
              const SizedBox(height: 10),
              MyTextField(
                keyboardType: TextInputType.number,
                controller: gradeController,
                hintText: register_24,
                obscureText: false,
                prefixIcon: Icons.functions,
                errorText: errorGradeMessage,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      errorGradeMessage;
                    });
                  } else if (value is double || value is int) {
                    gradeScore = value.toDouble();
                    setState(() {
                      errorGradeMessage = null;
                    });
                  } else {}
                  context.read<AuthCubit>().checkGradeScore(gradeScore);
                },
              ),
            ],
          ),
        ),
      ];
  //End of Stepper method
  //-------------------------------------------------------------------------------
//BuildContext
  @override
  Widget build(BuildContext context) {
    //size
    final screenWidth = MediaQuery.of(context).size.width;
    //Language
    final localizations = AppLocalizations.of(context);
    final register1 = localizations != null ? localizations.register_1 : 'Default Text';
    final register2 = localizations != null ? localizations.register_2 : 'Default Text';
    final register3 = localizations != null ? localizations.register_3 : 'Default Text';
    final register4 = localizations != null ? localizations.register_4 : 'Default Text';
    final register5 = localizations != null ? localizations.register_5 : 'Default Text';
    final register6 = localizations != null ? localizations.register_6 : 'Default Text';
    final register_login_signin = localizations != null ? localizations.register_login_signin : 'Default Text';
    final register_email = localizations != null ? localizations.register_login_cpass__fg_mail : 'Default Text';
    final register_pass = localizations != null ? localizations.register_login_cpass__fg_pass : 'Default Text';
    final register_7 = localizations != null ? localizations.register_7_fullname : 'Default Text';
    final register_8 = localizations != null ? localizations.register_8_confirm_pass : 'Default Text';
    final register_9 = localizations != null ? localizations.register_9_idcard : 'Default Text';
    final register_10 = localizations != null ? localizations.register_10_dob : 'Default Text';
    final register_11 = localizations != null ? localizations.register_11_gender : 'Default Text';
    final register_12 = localizations != null ? localizations.register_12_phone : 'Default Text';
    final register_13 = localizations != null ? localizations.register_13_address : 'Default Text';
    final register_14 = localizations != null ? localizations.register_14_city : 'Default Text';
    final register_15 = localizations != null ? localizations.register_15_district : 'Default Text';
    final register_16 = localizations != null ? localizations.register_16_ward : 'Default Text';
    final register_17 = localizations != null ? localizations.register_17_addressline : 'Default Text';
    final register_18 = localizations != null ? localizations.register_18_school : 'Default Text';
    final register_18_1 = localizations != null ? localizations.register_18_1_nation : 'Default Text';
    final register_19 = localizations != null ? localizations.register_19_major : 'Default Text';
    final register_20 = localizations != null ? localizations.register_20_degree : 'Default Text';
    final register_21 = localizations != null ? localizations.register_21_certi : 'Default Text';
    final register_22 = localizations != null ? localizations.register_22_upfile : 'Default Text';
    final register_23 = localizations != null ? localizations.register_23_score : 'Default Text';
    final register_24 = localizations != null ? localizations.register_24_gscore : 'Default Text';
    final register_25 = localizations != null ? localizations.register_25_back : 'Default Text';
    final register_26 = localizations != null ? localizations.register_26_next : 'Default Text';
    final register_signup = localizations != null ? localizations.logout_3_signup : 'Default Text';
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorEmailState) {
          setState(() {
            errorEmailMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorNameState) {
          setState(() {
            errorNameMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorPasswordState) {
          setState(() {
            errorPasswordMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorConfrimPasswordState) {
          setState(() {
            errorConfrimPasswordMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorIDCardNumberState) {
          setState(() {
            errorIDCardNumberMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorDOBState) {
          setState(() {
            errorDateMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorPhoneState) {
          setState(() {
            errorPhoneMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorCityState) {
          setState(() {
            errorCityMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorDistrictState) {
          setState(() {
            errorDistrictMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorWardState) {
          setState(() {
            errorWardMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorAddressState) {
          setState(() {
            errorAddressMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorGenderErrorState) {
          setState(() {
            errorGenderMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorDegreeTypeState) {
          setState(() {
            errorDegreeMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorGradeTypeState) {
          setState(() {
            errorGradeTypeMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorGradeScore) {
          setState(() {
            errorGradeMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorCertificateTypeState) {
          setState(() {
            errorCertificateTypeMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthErrorState) {
          setState(() {
            errorMessage = state.error;
            isLoading = false;
          });
        } else if (state is AuthSuccessState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          isLoading = false;
        }
      },
      builder: (context, state) {
        if (state is AuthErrorState) {
          Future.microtask(() {
            setState(() {
              errorMessage = state.error;
            });
          });
          isLoading = false;
        } else if (state is AuthLoadingState) {
          const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthInitialState) {}
        return Stack(children: [
          Scaffold(
            backgroundColor: context.select((ThemeSettingCubit cubit) => cubit.state.scaffoldBackgroundColor),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.06),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: screenWidth * 0.3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButtonCircle(onPressed: () {
                          Navigator.pushNamed(context, '/logout');
                        }),
                        SizedBox(width: screenWidth * 0.01),
                        TextMonserats(
                          register1,
                          color: AppColor.redButton,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Container(width: screenWidth * 0.15)
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextMonserats(
                      register2,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor:
                                context.select((ThemeSettingCubit cubit) => cubit.state.scaffoldBackgroundColor),
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                onSurface: Colors.transparent,
                                primary: AppColor.redButton,
                                secondary: AppColor.redButton)),
                        child: Stepper(
                          physics: const ClampingScrollPhysics(),
                          type: StepperType.horizontal,
                          elevation: 0,
                          currentStep: currentStep,
                          onStepContinue: continueStep,
                          onStepCancel: cancelStep,
                          onStepTapped: onStepTapped,
                          controlsBuilder: controlsBuilder,
                          steps: getSteps(
                              register1,
                              register2,
                              register3,
                              register4,
                              register5,
                              register6,
                              register_login_signin,
                              register_email,
                              register_pass,
                              register_7,
                              register_8,
                              register_9,
                              register_10,
                              register_11,
                              register_12,
                              register_13,
                              register_14,
                              register_15,
                              register_16,
                              register_17,
                              register_18,
                              register_18_1,
                              register_19,
                              register_20,
                              register_21,
                              register_22,
                              register_23,
                              register_24,
                              register_25,
                              register_26,
                              register_signup),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Color(0xFFCBD5E1),
                      thickness: 1.0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            styledTextSpan(register6, color: textColor),
                            styledTextSpan(
                              register_signup,
                              color: AppColor.redButton,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xff7D1F1F), // Change the color of the underline
                              decorationStyle: TextDecorationStyle.solid, // Change the number of lines
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, "/login");
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (errorMessage != null)
                      Center(
                        child: TextMonserats(
                          errorMessage!,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
        ]);
      },
    );
  }
}
