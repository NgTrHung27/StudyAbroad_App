import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'language/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('vi')
  ];

  /// No description provided for @home_hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get home_hello;

  /// No description provided for @home_search.
  ///
  /// In en, this message translates to:
  /// **'Search here...'**
  String get home_search;

  /// No description provided for @home_action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get home_action;

  /// No description provided for @home_action_orange_Score1.
  ///
  /// In en, this message translates to:
  /// **'See your'**
  String get home_action_orange_Score1;

  /// No description provided for @home_action_orange_Score2.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get home_action_orange_Score2;

  /// No description provided for @home_action_green_News1.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get home_action_green_News1;

  /// No description provided for @home_action_green_News2.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get home_action_green_News2;

  /// No description provided for @home_action_blue_Comments1.
  ///
  /// In en, this message translates to:
  /// **'Contacts for'**
  String get home_action_blue_Comments1;

  /// No description provided for @home_action_blue_Comments2.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get home_action_blue_Comments2;

  /// No description provided for @home_action_blue_Schols1.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get home_action_blue_Schols1;

  /// No description provided for @home_action_blue_Schols2.
  ///
  /// In en, this message translates to:
  /// **'Scholarship'**
  String get home_action_blue_Schols2;

  /// No description provided for @home_exlore.
  ///
  /// In en, this message translates to:
  /// **'Explore School'**
  String get home_exlore;

  /// No description provided for @home_NewList.
  ///
  /// In en, this message translates to:
  /// **'What\'s News?'**
  String get home_NewList;

  /// No description provided for @profile_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profile_account;

  /// No description provided for @profile_account_profilesInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_account_profilesInfo;

  /// No description provided for @profile_account_profilesInfo_School.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get profile_account_profilesInfo_School;

  /// No description provided for @profile_account_profilesInfo_Major.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get profile_account_profilesInfo_Major;

  /// No description provided for @profile_account_changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profile_account_changePassword;

  /// No description provided for @profile_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get profile_status;

  /// No description provided for @profile_status_ps.
  ///
  /// In en, this message translates to:
  /// **'Profile Status'**
  String get profile_status_ps;

  /// No description provided for @profile_status_ps1.
  ///
  /// In en, this message translates to:
  /// **'Scholarship status'**
  String get profile_status_ps1;

  /// No description provided for @profile_status_ps2.
  ///
  /// In en, this message translates to:
  /// **'Tuition status'**
  String get profile_status_ps2;

  /// No description provided for @profile_setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get profile_setting;

  /// No description provided for @profile_setting_Language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_setting_Language;

  /// No description provided for @profile_setting_Screenmode.
  ///
  /// In en, this message translates to:
  /// **'Screen Mode'**
  String get profile_setting_Screenmode;

  /// No description provided for @profile_setting_Support.
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get profile_setting_Support;

  /// No description provided for @profile_logout_ss1.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout_ss1;

  /// No description provided for @profile_logout_ss2.
  ///
  /// In en, this message translates to:
  /// **'Personal Account'**
  String get profile_logout_ss2;

  /// No description provided for @logout_1.
  ///
  /// In en, this message translates to:
  /// **'Join with \nus to manage your future'**
  String get logout_1;

  /// No description provided for @logout_2.
  ///
  /// In en, this message translates to:
  /// **'Create account to manage your account today'**
  String get logout_2;

  /// No description provided for @logout_3_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get logout_3_signup;

  /// No description provided for @logout_4_signin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get logout_4_signin;

  /// No description provided for @logout_5_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get logout_5_home;

  /// No description provided for @register_1.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get register_1;

  /// No description provided for @register_2.
  ///
  /// In en, this message translates to:
  /// **'Create an account to mange your account today'**
  String get register_2;

  /// No description provided for @register_3.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get register_3;

  /// No description provided for @register_4.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get register_4;

  /// No description provided for @register_5.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get register_5;

  /// No description provided for @register_6.
  ///
  /// In en, this message translates to:
  /// **'Already have an accounta? '**
  String get register_6;

  /// No description provided for @register_login_signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get register_login_signin;

  /// No description provided for @register_login_cpass__fg_mail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get register_login_cpass__fg_mail;

  /// No description provided for @register_login_cpass__fg_pass.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get register_login_cpass__fg_pass;

  /// No description provided for @register_7_fullname.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get register_7_fullname;

  /// No description provided for @register_8_confirm_pass.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get register_8_confirm_pass;

  /// No description provided for @register_9_idcard.
  ///
  /// In en, this message translates to:
  /// **'Identity Card'**
  String get register_9_idcard;

  /// No description provided for @register_10_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get register_10_dob;

  /// No description provided for @register_11_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get register_11_gender;

  /// No description provided for @register_12_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get register_12_phone;

  /// No description provided for @register_13_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get register_13_address;

  /// No description provided for @register_14_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get register_14_city;

  /// No description provided for @register_15_district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get register_15_district;

  /// No description provided for @register_16_ward.
  ///
  /// In en, this message translates to:
  /// **'Ward'**
  String get register_16_ward;

  /// No description provided for @register_17_addressline.
  ///
  /// In en, this message translates to:
  /// **'Address Line'**
  String get register_17_addressline;

  /// No description provided for @register_18_school.
  ///
  /// In en, this message translates to:
  /// **'-Choose your school-'**
  String get register_18_school;

  /// No description provided for @register_18_1_nation.
  ///
  /// In en, this message translates to:
  /// **'Choose nation school-'**
  String get register_18_1_nation;

  /// No description provided for @register_19_major.
  ///
  /// In en, this message translates to:
  /// **'-Major-'**
  String get register_19_major;

  /// No description provided for @register_20_degree.
  ///
  /// In en, this message translates to:
  /// **'-Degree-'**
  String get register_20_degree;

  /// No description provided for @register_21_certi.
  ///
  /// In en, this message translates to:
  /// **'Chose certificate'**
  String get register_21_certi;

  /// No description provided for @register_22_upfile.
  ///
  /// In en, this message translates to:
  /// **'Upload file here'**
  String get register_22_upfile;

  /// No description provided for @register_23_score.
  ///
  /// In en, this message translates to:
  /// **'Overall Score'**
  String get register_23_score;

  /// No description provided for @register_24_gscore.
  ///
  /// In en, this message translates to:
  /// **'Grade Score'**
  String get register_24_gscore;

  /// No description provided for @register_25_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get register_25_back;

  /// No description provided for @register_26_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get register_26_next;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @login_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get login_welcome;

  /// No description provided for @login_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue your adventure'**
  String get login_continue;

  /// No description provided for @login_remember.
  ///
  /// In en, this message translates to:
  /// **'Remember me?'**
  String get login_remember;

  /// No description provided for @login_forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_forgot;

  /// No description provided for @login_donot.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_donot;

  /// No description provided for @forgot_1.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgot_1;

  /// No description provided for @forgot_2.
  ///
  /// In en, this message translates to:
  /// **'Enter your email for the verification proccess, we will send digits code to your email.'**
  String get forgot_2;

  /// No description provided for @forgot_3.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get forgot_3;

  /// No description provided for @forgot_4.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get forgot_4;

  /// No description provided for @forgot_5.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get forgot_5;

  /// No description provided for @chang_pass_1.
  ///
  /// In en, this message translates to:
  /// **'Want to change password?'**
  String get chang_pass_1;

  /// No description provided for @chang_pass_2.
  ///
  /// In en, this message translates to:
  /// **'Enter your email for the verification proccess, we will send digits code to your email.'**
  String get chang_pass_2;

  /// No description provided for @new_main.
  ///
  /// In en, this message translates to:
  /// **'Main News'**
  String get new_main;

  /// No description provided for @new_post.
  ///
  /// In en, this message translates to:
  /// **'School Post'**
  String get new_post;

  /// No description provided for @school_Australia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get school_Australia;

  /// No description provided for @school_Canada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get school_Canada;

  /// No description provided for @school_Korea.
  ///
  /// In en, this message translates to:
  /// **'Korea'**
  String get school_Korea;

  /// No description provided for @school_discover.
  ///
  /// In en, this message translates to:
  /// **'Discover more'**
  String get school_discover;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_noti.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get nav_noti;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @noti.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get noti;

  /// No description provided for @noti_1.
  ///
  /// In en, this message translates to:
  /// **'Please Sign in to continue using this service'**
  String get noti_1;

  /// No description provided for @noti_2.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get noti_2;

  /// No description provided for @noti_dele.
  ///
  /// In en, this message translates to:
  /// **'Delete Notifications'**
  String get noti_dele;

  /// No description provided for @pfs.
  ///
  /// In en, this message translates to:
  /// **'Profile Status'**
  String get pfs;

  /// No description provided for @pfs_step1.
  ///
  /// In en, this message translates to:
  /// **'Application has been submitted'**
  String get pfs_step1;

  /// No description provided for @pfs_step2.
  ///
  /// In en, this message translates to:
  /// **'Awaiting review'**
  String get pfs_step2;

  /// No description provided for @pfs_step3.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get pfs_step3;

  /// No description provided for @ai_chatting_nav.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get ai_chatting_nav;

  /// No description provided for @ai_chatting_title.
  ///
  /// In en, this message translates to:
  /// **'Gemini AI'**
  String get ai_chatting_title;

  /// No description provided for @ai_chatting_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with our AI to get more information'**
  String get ai_chatting_subtitle;

  /// No description provided for @ai_chatting_input.
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get ai_chatting_input;

  /// No description provided for @ai_chatting_desPic.
  ///
  /// In en, this message translates to:
  /// **'Describe this picture'**
  String get ai_chatting_desPic;

  /// No description provided for @chat_system.
  ///
  /// In en, this message translates to:
  /// **'Chat CEMC System'**
  String get chat_system;

  /// No description provided for @sch_Canada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get sch_Canada;

  /// No description provided for @sch_Australia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get sch_Australia;

  /// No description provided for @sch_Korea.
  ///
  /// In en, this message translates to:
  /// **'Korea'**
  String get sch_Korea;

  /// No description provided for @sch_explore.
  ///
  /// In en, this message translates to:
  /// **'Explore School'**
  String get sch_explore;

  /// No description provided for @sch_RvAllSch.
  ///
  /// In en, this message translates to:
  /// **'Review All Schools'**
  String get sch_RvAllSch;

  /// No description provided for @sch_DisMore.
  ///
  /// In en, this message translates to:
  /// **'Discover more'**
  String get sch_DisMore;

  /// No description provided for @sch_desc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sch_desc;

  /// No description provided for @sch_require.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get sch_require;

  /// No description provided for @sch_major.
  ///
  /// In en, this message translates to:
  /// **'Majors'**
  String get sch_major;

  /// No description provided for @sch_major_body.
  ///
  /// In en, this message translates to:
  /// **'Programs of'**
  String get sch_major_body;

  /// No description provided for @sch_scholarship.
  ///
  /// In en, this message translates to:
  /// **'Scholarships'**
  String get sch_scholarship;

  /// No description provided for @contact_page.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_page;

  /// No description provided for @contact_text.
  ///
  /// In en, this message translates to:
  /// **'Need assistance? Drop us a message, describing the problem you\'re experiencing'**
  String get contact_text;

  /// No description provided for @contact_title.
  ///
  /// In en, this message translates to:
  /// **'Select a title form'**
  String get contact_title;

  /// No description provided for @contact_school.
  ///
  /// In en, this message translates to:
  /// **'Select a school'**
  String get contact_school;

  /// No description provided for @contact_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get contact_name;

  /// No description provided for @contact_mail.
  ///
  /// In en, this message translates to:
  /// **'Enter your full email'**
  String get contact_mail;

  /// No description provided for @contact_phone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get contact_phone;

  /// No description provided for @contact_helps.
  ///
  /// In en, this message translates to:
  /// **'How can we help'**
  String get contact_helps;

  /// No description provided for @contact_mess.
  ///
  /// In en, this message translates to:
  /// **'Enter your message'**
  String get contact_mess;

  /// No description provided for @contact_send.
  ///
  /// In en, this message translates to:
  /// **'Send inquiry'**
  String get contact_send;

  /// No description provided for @error_connection.
  ///
  /// In en, this message translates to:
  /// **'Please connect to Wifi or Mobile Network'**
  String get error_connection;

  /// No description provided for @input_hintext.
  ///
  /// In en, this message translates to:
  /// **'Enter news'**
  String get input_hintext;

  /// No description provided for @cpSchool.
  ///
  /// In en, this message translates to:
  /// **'Compare School'**
  String get cpSchool;

  /// No description provided for @cpSchool2.
  ///
  /// In en, this message translates to:
  /// **'Quality Of Teaching'**
  String get cpSchool2;

  /// No description provided for @cpSchool3.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get cpSchool3;

  /// No description provided for @cpSchool4.
  ///
  /// In en, this message translates to:
  /// **'Graduation and Employment Rates'**
  String get cpSchool4;

  /// No description provided for @cpSchool5.
  ///
  /// In en, this message translates to:
  /// **'Student Sastisfaction'**
  String get cpSchool5;

  /// No description provided for @cpSchool6.
  ///
  /// In en, this message translates to:
  /// **'National and International Rankings'**
  String get cpSchool6;

  /// No description provided for @cpSchool7.
  ///
  /// In en, this message translates to:
  /// **'Financial Resources'**
  String get cpSchool7;

  /// No description provided for @scr_subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get scr_subject;

  /// No description provided for @scr_score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scr_score;

  /// No description provided for @scr_cmt.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get scr_cmt;

  /// No description provided for @scr_dwn.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get scr_dwn;

  /// No description provided for @scr_sms.
  ///
  /// In en, this message translates to:
  /// **'Semester'**
  String get scr_sms;

  /// No description provided for @schlar_null.
  ///
  /// In en, this message translates to:
  /// **'There are no scholarships available yet, please wait.'**
  String get schlar_null;

  /// No description provided for @reqest_sta.
  ///
  /// In en, this message translates to:
  /// **'Request Status'**
  String get reqest_sta;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @request_1.
  ///
  /// In en, this message translates to:
  /// **'Response Request'**
  String get request_1;

  /// No description provided for @request_2.
  ///
  /// In en, this message translates to:
  /// **'Request Responded'**
  String get request_2;

  /// No description provided for @resq.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get resq;

  /// No description provided for @resq_1.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get resq_1;

  /// No description provided for @resq_2.
  ///
  /// In en, this message translates to:
  /// **'Enter your content'**
  String get resq_2;

  /// No description provided for @resq_3.
  ///
  /// In en, this message translates to:
  /// **'Images uploaded'**
  String get resq_3;

  /// No description provided for @resq_4.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get resq_4;

  /// No description provided for @apply_now.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get apply_now;

  /// No description provided for @scholar_desc_textfield.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get scholar_desc_textfield;

  /// No description provided for @scholar_desc_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your reason for applying for scholarship...'**
  String get scholar_desc_hint;

  /// No description provided for @scholar_desc_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get scholar_desc_submit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
