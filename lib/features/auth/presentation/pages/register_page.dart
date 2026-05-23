// ignore_for_file: use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:collection/collection.dart';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/auth_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/auth_event.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/auth_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/functions/convert_imagetostring.dart';
import 'package:study_abroad_cemc_mobile/components/functions/dropdown.dart';
import 'package:study_abroad_cemc_mobile/components/functions/radio.dart';
import 'package:study_abroad_cemc_mobile/components/functions/text_field.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/style/simplebutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/textspan.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/models/country.dart';
import 'package:study_abroad_cemc_mobile/models/enum.dart';
import 'package:study_abroad_cemc_mobile/models/schools.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/base_lang.dart';

class RegisterPage extends BasePage {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BasePageState<RegisterPage> {
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
  String email = '',
      name = '',
      password = '',
      confirmpassword = '',
      phone = '',
      idCardNumber = '',
      dob = '';
  Schools? selectedSchoolObject;
  String? selectedSchool,
      selectedCountry,
      selectedProgram,
      selectedCity,
      selectedDistrict,
      selectedWard;
  String address = '';
  Gender? valueGender;
  DegreeType? valueDegree;
  GradeType? radioGradeTypeValue;
  double gradeScore = 0.0;
  CertificateType? selectedCertificateType;
  String certificateImg = '';
  bool isLoading = false;

  //End of Declare
  final usermailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final idCardNumberController = TextEditingController();
  final dateController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final gradeController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  int currentStep = 0;

  void userRegister() async {
    setState(() {
      isLoading = true;
    });
    String email = usermailController.text.trim();
    String name = usernameController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();
    String idCardNumber = idCardNumberController.text.trim();
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();
    String certificateImg = imageController.text.toString();

    if (dateController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    DateTime dob;
    try {
      dob = DateFormat('dd/MM/yyyy').parse(dateController.text.trim());
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    double gradeScore;
    try {
      gradeScore = double.parse(gradeController.text.trim());
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    String gradeScoreString = gradeScore.toString();

    if (!mounted) return;
    context.read<AuthBloc>().add(RegisterEvent(
        email: email,
        name: name,
        password: password,
        confirmPassword: confirmpassword,
        idCardNumber: idCardNumber,
        date: dob,
        phone: phone,
        selectedSchool: selectedSchool,
        selectedCountry: selectedCountry,
        selectedProgram: selectedProgram,
        selectedCity: selectedCity,
        selectedDistrict: selectedDistrict,
        selectedWard: selectedWard,
        address: address,
        valueGender: valueGender,
        valueDegree: valueDegree,
        radioGradeTypeValue: radioGradeTypeValue,
        gradeScore: gradeScoreString,
        selectedCertificateType: selectedCertificateType,
        certificateImg: certificateImg));
  }

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
      }
    }
    return null;
  }

  String getGenderLabel(Gender gender) {
    switch (gender) {
      case Gender.Male:
        return maleKey.tr();
      case Gender.Female:
        return femaleKey.tr();
    }
  }

  Future<void> openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 01, 01),
      firstDate: DateTime(1960),
      lastDate: DateTime(2010),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.redPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      if (picked.isAfter(DateTime(DateTime.now().year - 17))) {
        this.context.read<AuthBloc>().add(CheckDobEvent(picked));
      } else {
        setState(() {
          errorDateMessage = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetSchoolsAndCountriesEvent());
    context.read<AuthBloc>().add(GetCityEvent());
  }

  void continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep += 1;
      });
    }
  }

  void cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  void onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlsBuilder(BuildContext context, ControlsDetails details) {
    return currentStep == 2
        ? Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: SimpleButton(
                  backgroundColor: Colors.transparent,
                  borderColor: AppColor.redButton,
                  onPressed: () => details.onStepCancel?.call(),
                  child: TextMonserats(
                    registerBackKey.tr(),
                    color: AppColor.redButton,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: SimpleButton(
                    onPressed: userRegister,
                    child: TextMonserats(
                      logoutSignUpKey.tr(),
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
                    onPressed: () => details.onStepCancel?.call(),
                    child: TextMonserats(
                      registerBackKey.tr(),
                      color: AppColor.redButton,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 120),
              Expanded(
                child: SimpleButton(
                  onPressed: () => details.onStepContinue?.call(),
                  child: TextMonserats(
                    registerNextKey.tr(),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const SizedBox.shrink(),
        isActive: currentStep != 1 && currentStep != 2,
        label: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: TextMonserats(registerStep1Key.tr()),
        ),
        content: Column(
          children: [
            MyTextField(
              controller: usermailController,
              hintText: registerEmailKey.tr(),
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              prefixIcon: Icons.email,
              errorText: errorEmailMessage,
              onChanged: (value) {
                email = value;
                context.read<AuthBloc>().add(CheckEmailEvent(email));
                if (email.isEmpty) {
                  setState(() {});
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
              hintText: registerFullnameKey.tr(),
              textCapitalization: TextCapitalization.words,
              obscureText: false,
              prefixIcon: Icons.person,
              errorText: errorNameMessage,
              onChanged: (value) {
                name = value;
                context.read<AuthBloc>().add(CheckNameEvent(name));
                if (name.isEmpty) {
                  setState(() {});
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
              hintText: registerPasswordKey.tr(),
              obscureText: true,
              prefixIcon: Icons.lock,
              errorText: errorPasswordMessage,
              onChanged: (value) {
                password = value;
                context.read<AuthBloc>().add(CheckPasswordEvent(password));
                if (password.isEmpty) {
                  setState(() {});
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
              hintText: registerConfirmPassKey.tr(),
              obscureText: true,
              prefixIcon: Icons.lock_reset,
              errorText: errorConfrimPasswordMessage,
              onChanged: (value) {
                confirmpassword = value;
                context
                    .read<AuthBloc>()
                    .add(CheckConfirmPasswordEvent(password, confirmpassword));
                if (confirmpassword.isEmpty) {
                  setState(() {});
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
              hintText: registerIdCardKey.tr(),
              obscureText: false,
              prefixIcon: Icons.how_to_reg,
              errorText: errorIDCardNumberMessage,
              onChanged: (value) {
                idCardNumber = value;
                context
                    .read<AuthBloc>()
                    .add(CheckIdCardNumberEvent(idCardNumber));
                if (idCardNumber.isEmpty) {
                  setState(() {});
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
      Step(
        title: const SizedBox.shrink(),
        isActive: currentStep != 0 && currentStep != 2,
        label: TextMonserats(registerStep2Key.tr()),
        content: Column(
          children: [
            SizedBox(
                width: double.infinity,
                height: 73,
                child: GestureDetector(
                  onTap: () => openDatePicker(context),
                  child: AbsorbPointer(
                    child: MyTextField(
                      controller: dateController,
                      hintText: registerDobKey.tr(),
                      obscureText: false,
                      prefixIcon: Icons.date_range,
                      errorText: errorDateMessage,
                      onChanged: (v) {},
                    ),
                  ),
                )),
            const SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 73,
                    child: DropdownCustom<Gender>(
                      icon: Icons.wc,
                      hintText: registerGenderKey.tr(),
                      items: Gender.values,
                      selectedItem: valueGender,
                      errorText: errorGenderMessage,
                      onChanged: (Gender? newValueGender) {
                        if (newValueGender != null) {
                          setState(() {});
                        } else {
                          setState(() {
                            errorGenderMessage = null;
                          });
                        }
                        setState(() {
                          genderValueChanged(newValueGender);
                        });
                      },
                      itemLabel: (Gender gender) => getGenderLabel(gender),
                      isExpanded: false,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: MyTextField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    hintText: registerPhoneKey.tr(),
                    obscureText: false,
                    prefixIcon: Icons.phone,
                    errorText: errorPhoneMessage,
                    onChanged: (value) {
                      phone = value;
                      if (phone.isEmpty) {
                        setState(() {});
                      } else {
                        setState(() {
                          errorPhoneMessage = null;
                        });
                      }
                      context
                          .read<AuthBloc>()
                          .add(CheckPhoneNumberEvent(phone));
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextMonserats(registerAddressKey.tr()),
              ],
            ),
            const SizedBox(height: 12),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoadedCityState) {
                  lstCountry = state.country;
                }
                return DropdownCustom<Country>(
                  icon: Icons.location_city,
                  items: lstCountry,
                  selectedItem: selectedCity == null
                      ? null
                      : lstCountry.firstWhereOrNull(
                          (element) => element.name == selectedCity),
                  onChanged: (Country? newValueCountry) {
                    if (newValueCountry != null) {
                      cityChange(newValueCountry);
                      selectedDistrict = null;
                      selectedWard = null;
                    }
                  },
                  itemLabel: (Country country) => country.name,
                  hintText: registerCityKey.tr(),
                  isExpanded: false,
                );
              },
            ),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadedCityState) {
                    lstCountry = state.country;
                  }
                  return DropdownCustom<District>(
                    icon: Icons.map,
                    items: selectedCity == null
                        ? []
                        : lstCountry
                                .firstWhereOrNull(
                                    (element) => element.name == selectedCity)
                                ?.districts ??
                            [],
                    selectedItem: selectedDistrict == null
                        ? null
                        : lstCountry
                            .firstWhereOrNull(
                                (element) => element.name == selectedCity)
                            ?.districts
                            .firstWhereOrNull(
                                (element) => element.name == selectedDistrict),
                    onChanged: (District? newValueDistrict) {
                      setState(() {
                        districtChange(newValueDistrict);
                        selectedWard = null;
                      });
                    },
                    itemLabel: (District district) => district.name,
                    hintText: registerDistrictKey.tr(),
                    isExpanded: true,
                  );
                },
              )),
              const SizedBox(width: 15),
              Expanded(child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadedCityState) {
                    lstCountry = state.country;
                  }
                  final districts = selectedCity == null
                      ? <District>[]
                      : lstCountry
                              .firstWhereOrNull(
                                  (element) => element.name == selectedCity)
                              ?.districts ??
                          [];
                  final selectedDistrictObj = selectedDistrict == null
                      ? null
                      : districts.firstWhereOrNull(
                          (element) => element.name == selectedDistrict);
                  final wards = selectedDistrictObj?.wards ?? [];
                  return DropdownCustom<Ward>(
                    icon: Icons.location_on,
                    items: wards,
                    selectedItem: selectedWard == null
                        ? null
                        : wards.firstWhereOrNull(
                            (element) => element.name == selectedWard),
                    onChanged: (Ward? newValueWard) {
                      setState(() {
                        wardChange(newValueWard);
                      });
                    },
                    itemLabel: (Ward ward) => ward.name,
                    hintText: registerWardKey.tr(),
                    isExpanded: true,
                  );
                },
              )),
            ]),
            const SizedBox(height: 15),
            MyTextField(
              controller: addressController,
              hintText: registerAddressLineKey.tr(),
              obscureText: false,
              prefixIcon: Icons.home,
              onChanged: (value) {
                address = value;
              },
            ),
          ],
        ),
      ),
      Step(
        title: const SizedBox.shrink(),
        isActive: currentStep != 0 && currentStep != 1,
        label: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: TextMonserats(registerStep3Key.tr()),
        ),
        content: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoadedState) {
                        lstCountrySchool = state.countries;
                      }
                      return DropdownCustom<String>(
                        icon: Icons.location_city,
                        items: lstCountrySchool,
                        selectedItem: selectedCountry,
                        onChanged: (String? newValueCountry) {
                          setState(() {
                            selectedCountry = newValueCountry;
                          });
                        },
                        itemLabel: (String country) => country,
                        hintText: registerNationKey.tr(),
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
                Expanded(child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoadedState) {
                      lstschools = state.schools;
                    }
                    return DropdownCustom<Schools>(
                      icon: Icons.school,
                      items: lstschools,
                      selectedItem: selectedSchool == null
                          ? null
                          : lstschools.firstWhereOrNull(
                              (element) => element.name == selectedSchool),
                      onChanged: (Schools? newValueSchool) {
                        setState(() {
                          schoolChange(newValueSchool);
                          selectedProgram = null;
                        });
                      },
                      itemLabel: (Schools school) => school.name,
                      hintText: registerSchoolKey.tr(),
                      isExpanded: true,
                    );
                  },
                )),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoadedState) {
                        lstschools = state.schools;
                      }
                      return DropdownCustom<SchoolProgram>(
                        icon: Icons.history_edu,
                        items: selectedSchool == null
                            ? []
                            : selectedSchoolObject?.programs ?? [],
                        selectedItem: selectedProgram == null
                            ? null
                            : selectedSchoolObject?.programs?.firstWhereOrNull(
                                (element) => element.name == selectedProgram),
                        onChanged: (SchoolProgram? newValueProgram) {
                          setState(() {
                            programChange(newValueProgram);
                          });
                        },
                        itemLabel: (SchoolProgram program) => program.name,
                        hintText: registerMajorKey.tr(),
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
                    itemLabel: (DegreeType degreeType) =>
                        degreeType.toString().split('.').last,
                    hintText: registerDegreeKey.tr(),
                    isExpanded: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            DropdownCustom<CertificateType>(
              icon: Icons.bookmark_add,
              items: CertificateType.values,
              onChanged: (CertificateType? newValueCertificateType) {
                setState(() {
                  certificateTypeValueChanged(newValueCertificateType);
                });
              },
              selectedItem: selectedCertificateType,
              itemLabel: (CertificateType certificateType) =>
                  certificateType.toString().split('.').last,
              hintText: registerCertiKey.tr(),
              isExpanded: false,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 37,
              child: SimpleButton(
                backgroundColor: Colors.transparent,
                borderColor: AppColor.redButton,
                onPressed: getImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.upload_file, size: 21),
                    const SizedBox(width: 10),
                    TextMonserats(registerUploadFileKey.tr())
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextMonserats(registerScoreKey.tr()),
              ],
            ),
            RadioGroup<GradeType>(
              groupValue: radioGradeTypeValue,
              onChanged: (GradeType? newGradeTypeValue) {
                radioValueChanged(newGradeTypeValue);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomRadio<GradeType>(
                    value: GradeType.GPA,
                    title: 'GPA (?/4.0)',
                  ),
                  CustomRadio<GradeType>(
                    value: GradeType.CGPA,
                    title: 'GGPA (?/10.0)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            MyTextField(
              keyboardType: TextInputType.number,
              controller: gradeController,
              hintText: registerGradeScoreKey.tr(),
              obscureText: false,
              prefixIcon: Icons.functions,
              errorText: errorGradeMessage,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {});
                } else {
                  setState(() {
                    errorGradeMessage = null;
                  });
                }
                context
                    .read<AuthBloc>()
                    .add(CheckGradeScoreEvent(double.tryParse(value) ?? 0));
              },
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return BlocConsumer<AuthBloc, AuthState>(
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Stack(children: [
          Scaffold(
            backgroundColor: context.select(
                (ThemeSettingBloc bloc) => bloc.state.scaffoldBackgroundColor),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.06),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButtonCircle(onPressed: () {
                          Navigator.pushNamed(context, '/logout');
                        }),
                        TextMonserats(
                          registerTitleKey.tr(),
                          color: AppColor.redButton,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        const SizedBox(width: 50)
                      ],
                    ),
                    const SizedBox(height: 5),
                    TextMonserats(
                      registerSubtitleKey.tr(),
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            canvasColor: context.select(
                                (ThemeSettingBloc bloc) =>
                                    bloc.state.scaffoldBackgroundColor),
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
                          steps: getSteps(),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: AppColor.borderGrey,
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
                            styledTextSpan(registerHaveAccountKey.tr(),
                                color: textColor),
                            styledTextSpan(
                              logoutSignUpKey.tr(),
                              color: AppColor.redButton,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColor.redButton,
                              decorationStyle: TextDecorationStyle.solid,
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
