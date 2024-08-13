import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/configs/routes.dart'
    as configs;
import 'package:united_natives/medicle_center/lib/models/model_booking_item.dart';
import 'package:united_natives/medicle_center/lib/models/model_category.dart';
import 'package:united_natives/medicle_center/lib/models/model_deeplink.dart';
import 'package:united_natives/medicle_center/lib/models/model_filter.dart';
import 'package:united_natives/medicle_center/lib/models/model_image.dart';
import 'package:united_natives/medicle_center/lib/models/model_open_time.dart';
import 'package:united_natives/medicle_center/lib/models/model_picker.dart';
import 'package:united_natives/medicle_center/lib/models/model_product.dart';
import 'package:united_natives/medicle_center/lib/models/model_user.dart';
import 'package:united_natives/medicle_center/lib/models/model_webview.dart';
import 'package:united_natives/medicle_center/lib/screens/booking/booking.dart';
import 'package:united_natives/medicle_center/lib/screens/booking_detail/booking_detail.dart';
import 'package:united_natives/medicle_center/lib/screens/booking_management/booking_management.dart';
import 'package:united_natives/medicle_center/lib/screens/category/category.dart';
import 'package:united_natives/medicle_center/lib/screens/category_picker/category_picker.dart';
import 'package:united_natives/medicle_center/lib/screens/change_password/change_password.dart';
import 'package:united_natives/medicle_center/lib/screens/deeplink/deeplink.dart';
import 'package:united_natives/medicle_center/lib/screens/edit_profile/edit_profile.dart';
import 'package:united_natives/medicle_center/lib/screens/feedback/feedback.dart';
import 'package:united_natives/medicle_center/lib/screens/filter/filter.dart';
import 'package:united_natives/medicle_center/lib/screens/font_setting/font_setting.dart';
import 'package:united_natives/medicle_center/lib/screens/forgot_password/forgot_password.dart';
import 'package:united_natives/medicle_center/lib/screens/gallery/gallery.dart';
import 'package:united_natives/medicle_center/lib/screens/gallery_upload/gallery_upload.dart';
import 'package:united_natives/medicle_center/lib/screens/gps_picker/gps_picker.dart';
import 'package:united_natives/medicle_center/lib/screens/language_setting/language_setting.dart';
import 'package:united_natives/medicle_center/lib/screens/list_product/list_product.dart';
import 'package:united_natives/medicle_center/lib/screens/list_product/list_product2.dart';
import 'package:united_natives/medicle_center/lib/screens/open_time/open_time.dart';
import 'package:united_natives/medicle_center/lib/screens/picker/picker.dart';
import 'package:united_natives/medicle_center/lib/screens/product_detail/product_detail.dart';
import 'package:united_natives/medicle_center/lib/screens/profile/profile.dart';
import 'package:united_natives/medicle_center/lib/screens/review/review.dart';
import 'package:united_natives/medicle_center/lib/screens/scan/scan.dart';
import 'package:united_natives/medicle_center/lib/screens/search_history/search_history.dart';
import 'package:united_natives/medicle_center/lib/screens/setting/setting.dart';
import 'package:united_natives/medicle_center/lib/screens/signin/signin.dart';
import 'package:united_natives/medicle_center/lib/screens/signup/signup.dart';
import 'package:united_natives/medicle_center/lib/screens/social_network/social_network.dart';
import 'package:united_natives/medicle_center/lib/screens/submit/submit.dart';
import 'package:united_natives/medicle_center/lib/screens/submit_success/submit_success.dart';
import 'package:united_natives/medicle_center/lib/screens/tags_picker/tags_picker.dart';
import 'package:united_natives/medicle_center/lib/screens/theme_setting/theme_setting.dart';
import 'package:united_natives/medicle_center/lib/screens/web/web.dart';
import 'package:united_natives/model/appointment.dart';
import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/model/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/model/get_all_doctor.dart';
import 'package:united_natives/model/patient_detail_model.dart';
import 'package:united_natives/model/patient_homepage_model.dart';
import 'package:united_natives/model/visited_patient_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:united_natives/pages/Blogpage/Participate_catagory.dart';
import 'package:united_natives/pages/Blogpage/blog_catagory_2.dart';
import 'package:united_natives/pages/Blogpage/blog_detailed_view_doctor.dart';
import 'package:united_natives/pages/Diabites/medication_checklist.dart';
import 'package:united_natives/pages/Diabites/physical_activity.dart';
import 'package:united_natives/pages/Doc_notifications/notifications_page.dart';
import 'package:united_natives/pages/PaypalPaymentPage/paypal_payment_page.dart';
import 'package:united_natives/pages/add_class/add_class_screen.dart';
import 'package:united_natives/pages/appointment/doctor_appointment.dart';
import 'package:united_natives/pages/booking/step3/time_slot_drawer.dart';
import 'package:united_natives/pages/direct%20appointment/choose_direct_appointment_screen.dart';
import 'package:united_natives/pages/doctor/add_ihdoc_notes_page.dart';
import 'package:united_natives/pages/doctor/add_my_doctor_page.dart';
import 'package:united_natives/pages/doctor/add_mydoc_notes_page.dart';
import 'package:united_natives/pages/doctor/doctorProfile_drawer.dart';
import 'package:united_natives/pages/doctor/edit_doctor_page.dart';
import 'package:united_natives/pages/doctor/edit_my_doctor_notes_page.dart';
import 'package:united_natives/pages/doctor/my_doctor_message_list.dart';
import 'package:united_natives/pages/doctor/my_doctor_notes_screen.dart';
import 'package:united_natives/pages/hospital_structure/hospital_structure_screen.dart';
import 'package:united_natives/pages/login/login_page_auth.dart';
import 'package:united_natives/pages/login/phoneAuthScreen.dart';
import 'package:united_natives/pages/login/phoneAuthScreen2.dart';
import 'package:united_natives/pages/login/phoneAuthScreen3.dart';
import 'package:united_natives/pages/myPatientMessageList/my_patient_message_list.dart';
import 'package:united_natives/pages/notifications/docnotifications_page.dart';
import 'package:united_natives/pages/notifications/patient_notification_page.dart';
import 'package:united_natives/pages/on%20board/Showcaseview/screens/landing_page.dart';
import 'package:united_natives/pages/on%20board/intro.dart';
import 'package:united_natives/pages/patient/my_patient_list_detail_page.dart';
import 'package:united_natives/pages/personal_medication_notes/add_personal_medication_notes.dart';
import 'package:united_natives/pages/personal_medication_notes/all_personal_medication_list_screen.dart';
import 'package:united_natives/pages/prescription/doctor_home_all_prescription_page.dart';
import 'package:united_natives/pages/prescription/patient_home_all_prescription_page.dart';
import 'package:united_natives/pages/report/report.dart';
import 'package:united_natives/pages/schedule_class/dr_schedule_class.dart';
import 'package:united_natives/pages/schedule_class/patient_schedule_class.dart';
import 'package:united_natives/pages/services/dr_services.dart';
import 'package:united_natives/pages/services/patient_services.dart';
import 'package:united_natives/pages/signup/doc_signup_page.dart';
import 'package:united_natives/pages/terms%20and%20conditions/privacy_policy.dart';
import 'package:united_natives/utils/utils.dart';
import '../pages/ADD prescription/add prescription.dart';
import '../pages/Availability_page/availability.dart';
import '../pages/Blogpage/blog_catagory.dart';
import '../pages/Blogpage/blog_detailed_view.dart';
import '../pages/Blogpage/blog_list.dart';
import '../pages/Blogpage/blog_list2.dart';
import '../pages/Diabites/Blood Pressure.dart';
import '../pages/Diabites/Diabetes_table.dart';
import '../pages/Diabites/Food.dart';
import '../pages/Diabites/Mood.dart';
import '../pages/Diabites/Sleep.dart';
import '../pages/Diabites/Sober day.dart';
import '../pages/Diabites/Weight loss.dart';
import '../pages/Diabites/Women Health Tracker.dart';
import '../pages/Self-Monitoring/selfmonitoring.dart';
import '../pages/appointment/appointment_detail_page.dart';
import '../pages/appointment/my_appointments_page.dart';
import '../pages/booking/filter/filter_page.dart' hide Availability;
import '../pages/booking/step2/choose_doctor_page.dart';
import '../pages/booking/step3/time_slot_page.dart';
import '../pages/booking/step4/patient_details_page.dart';
import '../pages/booking/step5/appointment_booked_page.dart';
import '../pages/contact/Contact.dart';
import '../pages/doctor/doctor_profile_page.dart';
import '../pages/doctor/my_doctor_list_page.dart';
import '../pages/doctorlogin/doctor_login_page.dart';
import '../pages/doctormessages/messages_detail_page.dart';
import '../pages/doctorprofile/edit_profile_page.dart';
import '../pages/forgot/forgot_password_page.dart';
import '../pages/home/home.dart' as home;
import '../pages/home2/home.dart';
import '../pages/language/change_laguage_page.dart';
import '../pages/messages/messages_detail_page.dart';
import '../pages/notifications/docnotification_settings_page.dart';
import '../pages/patient/my_patient_list_page.dart';
import '../pages/patientvisit/visit_detail_page.dart';
import '../pages/paymentregister/payment_register.dart';
import '../pages/prescription/prescription_detail_page.dart';
import '../pages/prescription/prescription_list_page.dart';
import '../pages/profile/edit_profile_page.dart';
import '../pages/reminder/remainder_page.dart';
import '../pages/request/request.dart';
import '../pages/settings/about_us.dart';
import '../pages/signup/signup_page.dart';
import '../pages/splash_page.dart';
import '../pages/telehealth/telehealth.dart';
import '../pages/terms and conditions/terms and conditions.dart';
import '../pages/visit/visit_detail_page.dart';
import '../utils/constants.dart';
import 'routes.dart';

class RouteGenerator {
  String? email, password, authPIN, webViewUrl, secretPin;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    String email, password, webViewUrl, secretPin;
    email = Config.getEmail();
    password = Config.getPassword();
    secretPin = Prefs.getString(Prefs.SecretPin) ?? "";
    webViewUrl =
        "${Constants.webUrl}?userEmail=$email&userPassword=$password&securePinInp=$secretPin";

    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashPage());

      // case Routes.Showcase:
      //   return CupertinoPageRoute(builder: (_) => BubbleShowcaseDemoWidget());

      case Routes.login:
        return CupertinoPageRoute(builder: (_) => const LoginPageA());

      case Routes.doctorlogin:
        return CupertinoPageRoute(builder: (_) => const DoctorLoginPage());

      case Routes.blogdetailedview:
        // return CupertinoPageRoute(builder: (_) => BlogDetailedViewPage());
        return CupertinoPageRoute(
            builder: (_) =>
                BlogDetailedViewPage(id: settings.arguments.toString()));
      case Routes.blogdetailedviewdoctor:
        // return CupertinoPageRoute(builder: (_) => BlogDetailedViewPage());
        return CupertinoPageRoute(
            builder: (_) => BlogDetailedViewDoctorPage(
                  id: settings.arguments.toString(),
                ));

      case Routes.notification:
        return CupertinoPageRoute(builder: (_) => const NotificationsPage());
      case Routes.patientNotification:
        return CupertinoPageRoute(
            builder: (_) => const PatientNotificationPage());

      case Routes.intro:
        return CupertinoPageRoute(builder: (_) => const OnBoardingPage());

      case Routes.aboutus:
        return CupertinoPageRoute(builder: (_) => const AboutUNH());

      case Routes.signup:
        return CupertinoPageRoute(builder: (_) => const SignupPage());
      case Routes.docSignup:
        return CupertinoPageRoute(builder: (_) => const DocSignupPage());

      case Routes.paymentregister:
        return CupertinoPageRoute(builder: (_) => const PaymentRegister());

      case Routes.forgotPassword:
        return CupertinoPageRoute(builder: (_) => const ForgotPasswordPage());

      case Routes.diabetes:
        return CupertinoPageRoute(builder: (_) => const Diabetes());

      case Routes.landingPage:
        return CupertinoPageRoute(builder: (_) => LandingPage());

      case Routes.bp:
        return CupertinoPageRoute(builder: (_) => const BloodPressure());
      case Routes.weightloss:
        return CupertinoPageRoute(builder: (_) => const Weightloss());
      case Routes.sober:
        return CupertinoPageRoute(builder: (_) => const SoberDay());
      case Routes.wht:
        return CupertinoPageRoute(builder: (_) => const WomenHealth());
      case Routes.food:
        return CupertinoPageRoute(builder: (_) => const Food());
      case Routes.sleep:
        return CupertinoPageRoute(builder: (_) => const Sleep());
      case Routes.mood:
        return CupertinoPageRoute(builder: (_) => const Mood());

      case Routes.physicalActivity:
        return CupertinoPageRoute(builder: (_) => const PhysicalActivity());
      case Routes.medication:
        return CupertinoPageRoute(builder: (_) => const MedicationCheckList());

      case Routes.home:
        return CupertinoPageRoute(builder: (_) => const home.Home());

      case Routes.home2:
        return CupertinoPageRoute(builder: (_) => const Home2());

      case Routes.contact:
        return CupertinoPageRoute(builder: (_) => const Contact());
      case Routes.reportAProblem:
        return CupertinoPageRoute(builder: (_) => const Report());

      case Routes.termsAndConditions:
        return CupertinoPageRoute(builder: (_) => const TermsAndCondition());

      case Routes.privacyPolicy:
        return CupertinoPageRoute(builder: (_) => const PrivacyPolicy());

      // case Routes.nearby:
      //   return CupertinoPageRoute(builder: (_) {
      //     return App();
      //   });

      case Routes.selfmonitoring:
        return CupertinoPageRoute(builder: (_) => const SelfMonitering());

      case Routes.addClass:
        return CupertinoPageRoute(builder: (_) => const AddClassScreen());

      case Routes.availability:
        return CupertinoPageRoute(builder: (_) => const AvailabilityPage());

      case Routes.addprescription:
        return CupertinoPageRoute(
            builder: (_) => AddPrescription(
                  patientAppoint: settings.arguments as PatientAppoint,
                ));

      case Routes.message:
        return CupertinoPageRoute(builder: (_) => const MyDoctorMessageList());
      case Routes.messagePatient:
        return CupertinoPageRoute(builder: (_) => const MyPatientMessageList());

      case Routes.filter:
        return CupertinoPageRoute(
          builder: (_) => FilterPage(
            id: settings.arguments.toString(),
          ),
          fullscreenDialog: true,
        );

      // case Routes.bookingStep1:
      //   return CupertinoPageRoute(
      //     builder: (_) => HealthConcernPage(),
      //     fullscreenDialog: true,
      //   );

      case Routes.bookingStep2:
        return CupertinoPageRoute(
            builder: (_) => ChooseDoctorPage(
                  id: settings.arguments.toString(),
                ));

      case Routes.bookingStep3:
        return CupertinoPageRoute(
            builder: (_) => TimeSlotPage(
                  doctorDetails: settings.arguments as DoctorSpecialities,
                ));

      case Routes.bookingStepDrawer3:
        return CupertinoPageRoute(
            builder: (_) => TimeSlotPage2(
                  doctorDetails: settings.arguments as Appointment,
                ));

      case Routes.bookingStep4:
        return CupertinoPageRoute(
            builder: (_) => PatientDetailsPage(
                  navigationModel: settings.arguments as NavigationModel,
                  // items:settings.arguments,
                ));

      case Routes.bookingStep5:
        return CupertinoPageRoute(
            builder: (_) => AppointmentBookedPage(
                  navigationModel: settings.arguments as NavigationModel,
                ));

      case Routes.appointmentDetail:
        return CupertinoPageRoute(
            builder: (_) => AppointmentDetailPage(
                  navigationModel: settings.arguments as NavigationModel,
                ));

      case Routes.visitDetail:
        return CupertinoPageRoute(
            builder: (_) => VisitDetailPage(
                  doctorDetails: settings.arguments as Appointment,
                ));

      case Routes.prescriptionDetail:
        return CupertinoPageRoute(
            builder: (_) => PrescriptionDetailPage(
                  patientPrescription:
                      settings.arguments as List<Prescriptions>,
                ));

      case Routes.patientHomeAllPrescriptionPage:
        return CupertinoPageRoute(
            builder: (_) => const PatientHomeAllPrescriptionPage());

      case Routes.prescriptionpage:
        return CupertinoPageRoute(
            builder: (_) =>
                PrescriptionPage(appointmentId: settings.arguments.toString()));

      case Routes.doctorprescriptionpage:
        return CupertinoPageRoute(
            builder: (_) => DoctorPrescriptionPage(
                  patientData: settings.arguments as VisitedPatient,
                ));

      case Routes.blogpage:
        return CupertinoPageRoute(builder: (_) => const BlogPage());

      case Routes.blogpage1:
        return CupertinoPageRoute(builder: (_) => const BlogPage1());

      case Routes.survey:
        return CupertinoPageRoute(
          builder: (_) => WebViewLoad(url: webViewUrl),
        );

      case Routes.scheduleClass:
        return CupertinoPageRoute(builder: (_) => const ScheduleClass());

      case Routes.drScheduleClass:
        return CupertinoPageRoute(builder: (_) => const DrScheduleClass());
      case Routes.servicesDoctor:
        return CupertinoPageRoute(builder: (_) => const DoctorServices());
      case Routes.servicesPatient:
        return CupertinoPageRoute(builder: (_) => const PatientServices());

      case Routes.request:
        return CupertinoPageRoute(builder: (_) => const Request());
      // case Routes.directAppointment:
      //   return CupertinoPageRoute(builder: (_) => DirectAppointmentScreen());
      case Routes.directAppointment:
        return CupertinoPageRoute(
            builder: (_) => const ChooseDirectAppointmentScreen());

      case Routes.allPersonalMedicationNotesList:
        return CupertinoPageRoute(
            builder: (_) => const PersonalMedicationListScreen());

      case Routes.addPersonalMedicationNotes:
        return CupertinoPageRoute(
            builder: (_) => const AddPersonalMedicationNotesScreen());

      case Routes.chatDetail:
        return CupertinoPageRoute(
            builder: (_) => MessagesDetailPage(
                  doctor: settings.arguments as Doctor,
                ));

      case Routes.doctorchatDetail:
        return CupertinoPageRoute(
            builder: (_) => const DoctorMessagesDetailPage());

      case Routes.doctorProfile:
        return CupertinoPageRoute(
            builder: (_) => DoctorProfilePage(
                  doctor: settings.arguments as DoctorSpecialities,
                ));

      case Routes.doctorProfile2:
        return CupertinoPageRoute(
            builder: (_) => DoctorProfilePage2(
                  doctor: settings.arguments as Appointment,
                ));

      case Routes.myDoctorProfile:
        return CupertinoPageRoute(
            builder: (_) => MyDoctorNotesScreen(
                  doctor: settings.arguments.toString(),
                ));

      case Routes.addMyDoctor:
        return CupertinoPageRoute(builder: (_) => const AddMyDoctorScreen());
      case Routes.editMyDoctor:
        return CupertinoPageRoute(
            builder: (_) => EditMyDoctorScreen(
                  doctor: settings.arguments as DoctorData,
                ));

      case Routes.addIHNotes:
        return CupertinoPageRoute(
            builder: (_) => AddIHNotesScreen(
                  doctorId: settings.arguments,
                ));
      case Routes.addMyDocNotes:
        return CupertinoPageRoute(
            builder: (_) => AddMyDocNotesScreen(
                  doctor: settings.arguments as DoctorData,
                ));

      case Routes.editMyDocNotes:
        return CupertinoPageRoute(
            builder: (_) => UpdateDocNotesScreen(
                  doctor: settings.arguments as DoctorData,
                ));

      case Routes.editProfile:
        return CupertinoPageRoute(builder: (_) => const EditProfilePage());

      case Routes.doceditprofile:
        return CupertinoPageRoute(builder: (_) => const DocEditProfilePage());

      case Routes.changeLanguage:
        return CupertinoPageRoute(builder: (_) => const ChangeLanguagePage());

      case Routes.notificationSettings:
        return CupertinoPageRoute(
            builder: (_) => const NotificationSettingsPage());

      case Routes.myDoctors:
        return CupertinoPageRoute(builder: (_) => const MyDoctorListPage());
      case Routes.hospitalStructure:
        return CupertinoPageRoute(
            builder: (_) => const HospitalStructureScreen());

      case Routes.mypatient:
        return CupertinoPageRoute(builder: (_) => const MyPatientListPage());

      case Routes.patientvistpage:
        return CupertinoPageRoute(
            builder: (_) => PatientVisitDetailPage(
                patient: settings.arguments as PatientAppoint));
      case Routes.patientListVisitPage:
        return CupertinoPageRoute(
            builder: (_) => PatientListVisitDetailPage(
                patientData: settings.arguments as PatientData));

      case Routes.myAppointments:
        return CupertinoPageRoute(builder: (_) => const MyAppointmentsPage());

      case Routes.appointments:
        return CupertinoPageRoute(builder: (_) => const MyAppointmentsDoctor());
      case Routes.catagoryblog:
        return CupertinoPageRoute(builder: (_) => CategoryView());
      case Routes.catagoryblogdoctor:
        return CupertinoPageRoute(builder: (_) => CategoryViewDoctor());
      case Routes.pCatagoryBlog:
        return CupertinoPageRoute(builder: (_) => const PCategoryView());

      case Routes.remainder:
        return CupertinoPageRoute(builder: (_) => const RemainderPage());

      case Routes.telehealth:
        return CupertinoPageRoute(builder: (_) => const TeleHealth());

      case Routes.docnotification:
        return CupertinoPageRoute(builder: (_) => const DocNotificationsPage());

      case Routes.phoneAuthScreen:
        return CupertinoPageRoute(builder: (_) => const PhoneVerification());
      case Routes.phoneAuthScreen2:
        return CupertinoPageRoute(builder: (_) => const PhoneVerification2());
      case Routes.phoneAuthScreen3:
        return CupertinoPageRoute(builder: (_) => const PhoneVerification3());
      // case Routes.phoneAuthScreen4:
      //   return CupertinoPageRoute(builder: (_) => PhoneVerification4());
      // case Routes.phoneAuthScreen5:
      //   return CupertinoPageRoute(builder: (_) => PhoneVerification5());
      // case Routes.phoneAuthScreen6:
      //   return CupertinoPageRoute(builder: (_) => PhoneVerification6());
      // case Routes.phoneAuthScreen7:
      //   return CupertinoPageRoute(builder: (_) => PhoneVerification7());

      /// Acknowledgement Route
      case Routes.payPalPage:
        final arguments = args as Map;
        final onFinish = arguments['onFinish'];
        final paypalPaymentModel = arguments['paypalPaymentModel'];
        return CupertinoPageRoute(
          builder: (_) => PaypalPayment(
            paypalPaymentModel: paypalPaymentModel,
            onFinish: onFinish,
          ),
          settings: RouteSettings(
            name: Routes.payPalPage,
            arguments: args,
          ),
        );
      //   return MaterialPageRoute(
      //     builder: (_) => AcknowledgementScreen(
      //       messageId: messageId,
      //       chatGroupId: chatGroupId,
      //     ),
      //     settings: RouteSettings(
      //       name: chatRoute,
      //       arguments: args,
      //     ),
      //   );
      //
      // return _errorRoute();

      case configs.Routes.signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn(from: settings.arguments as String);
          },
          fullscreenDialog: true,
        );

      case configs.Routes.signUp:
        return MaterialPageRoute(
          builder: (context) {
            return const SignUp();
          },
        );

      case configs.Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ForgotPassword();
          },
        );

      case configs.Routes.productDetail:
        return MaterialPageRoute(
          builder: (context) {
            return ProductDetail(item: settings.arguments as ProductModel);
          },
        );

      case configs.Routes.searchHistory:
        return MaterialPageRoute(
          builder: (context) {
            return const SearchHistory();
          },
          fullscreenDialog: true,
        );

      case configs.Routes.category:
        return MaterialPageRoute(
          builder: (context) {
            return Category(item: settings.arguments as CategoryModel);
          },
        );

      case configs.Routes.profile:
        return MaterialPageRoute(
          builder: (context) {
            return Profile(user: settings.arguments as UserModel);
          },
        );

      case configs.Routes.submit:
        return MaterialPageRoute(
          builder: (context) {
            return Submit(item: settings.arguments as ProductModel);
          },
          fullscreenDialog: true,
        );

      case configs.Routes.editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfile();
          },
        );

      case configs.Routes.changePassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ChangePassword();
          },
        );

      case configs.Routes.changeLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return const LanguageSetting();
          },
        );

      case configs.Routes.themeSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const ThemeSetting();
          },
        );

      case configs.Routes.filterSubRoute:
        return MaterialPageRoute(
          builder: (context) {
            return Filter(filter: settings.arguments as FilterModel);
          },
          fullscreenDialog: true,
        );

      case configs.Routes.review:
        return MaterialPageRoute(
          builder: (context) {
            return Review(product: settings.arguments as ProductModel);
          },
        );

      case configs.Routes.setting:
        return MaterialPageRoute(
          builder: (context) {
            return const Setting();
          },
        );

      case configs.Routes.fontSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const FontSetting();
          },
        );

      case configs.Routes.writeReview:
        return MaterialPageRoute(
          builder: (context) => WriteReview(
            product: settings.arguments as ProductModel,
          ),
        );

      case configs.Routes.listProduct:
        return MaterialPageRoute(
          builder: (context) {
            log('category------>');
            return ListProduct(category: settings.arguments as CategoryModel);
          },
        );

      case configs.Routes.listProduct2:
        return MaterialPageRoute(
          builder: (context) {
            return ListProduct2(
              contentData: settings.arguments as Map<String, dynamic>,
            );
          },
        );

      case configs.Routes.gallery:
        return MaterialPageRoute(
          builder: (context) {
            return Gallery(product: settings.arguments as ProductModel);
          },
          fullscreenDialog: true,
        );

      case configs.Routes.galleryUpload:
        return MaterialPageRoute(
          builder: (context) {
            return GalleryUpload(
              images: settings.arguments as List<ImageModel>,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.categoryPicker:
        return MaterialPageRoute(
          builder: (context) {
            return CategoryPicker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.gpsPicker:
        return MaterialPageRoute(
          builder: (context) {
            return GPSPicker(
              picked: settings.arguments as LocationData,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.picker:
        return MaterialPageRoute(
          builder: (context) {
            return Picker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.openTime:
        return MaterialPageRoute(
          builder: (context) {
            List<OpenTimeModel> arguments = [];
            if (settings.arguments != null) {
              arguments = settings.arguments as List<OpenTimeModel>;
            }
            return OpenTime(
              selected: arguments,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.socialNetwork:
        return MaterialPageRoute(
          builder: (context) {
            return SocialNetwork(
              socials: settings.arguments as Map<String, dynamic>,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.submitSuccess:
        return MaterialPageRoute(
          builder: (context) {
            return const SubmitSuccess();
          },
          fullscreenDialog: true,
        );

      case configs.Routes.tagsPicker:
        return MaterialPageRoute(
          builder: (context) {
            return TagsPicker(
              selected: settings.arguments as List<String>,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.webView:
        return MaterialPageRoute(
          builder: (context) {
            return Web(
              web: settings.arguments as WebViewModel,
            );
          },
          fullscreenDialog: true,
        );

      case configs.Routes.booking:
        return MaterialPageRoute(
          builder: (context) {
            return Booking(
              id: settings.arguments as int,
            );
          },
        );

      case configs.Routes.bookingManagement:
        return MaterialPageRoute(
          builder: (context) {
            return const BookingManagement();
          },
        );

      case configs.Routes.bookingDetail:
        return MaterialPageRoute(
          builder: (context) {
            return BookingDetail(
              item: settings.arguments as BookingItemModel,
            );
          },
        );

      case configs.Routes.scanQR:
        return MaterialPageRoute(
          builder: (context) {
            return const ScanQR();
          },
        );

      case configs.Routes.deepLink:
        return MaterialPageRoute(
          builder: (context) {
            return DeepLink(
              deeplink: settings.arguments as DeepLinkModel,
            );
          },
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
