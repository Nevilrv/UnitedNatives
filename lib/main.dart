import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/book_appointment_controller.dart';
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/controller/self_monitoring_controller.dart';
import 'package:united_natives/controller/theme_controlller.dart';
import 'package:united_natives/controller/user_update_contoller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/blocs/language/language_cubit.dart';
import 'package:united_natives/medicle_center/lib/blocs/theme/theme_cubit.dart';
import 'package:united_natives/medicle_center/lib/configs/language.dart';
import 'package:united_natives/medicle_center/lib/configs/preferences.dart';
import 'package:united_natives/medicle_center/lib/main.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/pages/splash_page.dart';
import 'package:united_natives/sevices/app_notification.dart';
import 'package:united_natives/utils/app_themes.dart';
import 'package:united_natives/viewModel/direct_doctor_view_model.dart';
import 'package:united_natives/viewModel/log_out_view_model.dart';
import 'package:united_natives/viewModel/patient_request_viewModel.dart';
import 'package:united_natives/viewModel/patient_scheduled_class_viewmodel.dart';
import 'package:united_natives/viewModel/room_view_model.dart';
import 'package:united_natives/viewModel/scheduled_class_viewmodel.dart';
import 'package:united_natives/viewModel/services_view_model.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'controller/user_controller.dart';
import 'routes/route_generator.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: "AIzaSyCA_Tt5erwNZeaH34FQLS8kb2XBhEH60HE",
      //   appId: "1:1007237012704:android:d6cf3d5245212288178485",
      //   messagingSenderId: "1007237012704",
      //   projectId: "unh-app-58bd8",
      // ),
      );
  await EasyLocalization.ensureInitialized();
  initializeDateFormatting('', null);

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FirebaseCrashlytics.instance.crash();
  await WakelockPlus.enable();

  Prefs.load();
  Preferences.setPreferences();
  // PatientHomeScreenController().aboutUsPrivacyPolicy();
  // PatientHomeScreenController().getSortedPatientChatList();
  Bloc.observer = AppBlocObserver();
  runZonedGuarded(() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    return runApp(
      EasyLocalization(
        supportedLocales: const [
          // Locale('en'),
          // //Locale('de', 'DE'),
          // //Locale('ar', 'DZ'),
          // Locale('es'),
          // Locale('it'),
          // Locale('pt'),
          //Locale('fr', 'FR'),
          Locale('en'),
          Locale('ar'),
          Locale('da'),
          Locale('el'),
        ],
        fallbackLocale: const Locale('en'),
        path: 'assets/locale',
        // saveLocale: false,
        // startLocale: Locale('en'),
        useOnlyLangCode: true,
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });

  await AppNotificationHandler.getFcmToken();
  FirebaseMessaging.onBackgroundMessage(
      AppNotificationHandler.firebaseMessagingBackgroundHandler);

  DarwinInitializationSettings initializationSettings =
      const DarwinInitializationSettings(
          requestAlertPermission: true,
          requestSoundPermission: true,
          requestBadgePermission: true);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(AppNotificationHandler.channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,
    sound: false,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future onSelectNotification(String payload) async {
  return Future.value(0);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    BlocProvider<LanguageCubit>(
      create: (context) => LanguageCubit(),
    );
    super.initState();
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context1) {
    WakelockPlus.enable();
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, lang) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, theme) {
              return GetBuilder<ThemeController>(
                builder: (controller) {
                  return GetMaterialApp(
                    builder: (context, widget) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: const TextScaler.linear(0.98),
                          boldText: false,
                        ),
                        child: ResponsiveWrapper.builder(
                          BouncingScrollWrapper.builder(context, widget!),
                          maxWidth: 1200,
                          minWidth: 450,
                          defaultScale: true,
                          breakpoints: const [
                            ResponsiveBreakpoint.resize(450, name: MOBILE),
                            ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
                            ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
                            ResponsiveBreakpoint.resize(800, name: DESKTOP),
                            ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
                          ],
                        ),
                      );
                    },
                    title: 'United Natives',
                    home: const SplashPage(),
                    initialBinding: BaseBindings(),
                    onGenerateRoute: RouteGenerator.generateRoute,
                    supportedLocales: AppLanguage.supportLanguage,
                    localizationsDelegates: [Translate(lang).delegate],
                    locale: lang,
                    themeMode: ThemeMode.system,
                    debugShowCheckedModeBanner: false,
                    theme:
                        controller.isDark ? Themes().isDark : Themes().isLight,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    WidgetsFlutterBinding.ensureInitialized();

    Get.put<UserController>(UserController(), permanent: true);
    Get.put<BookAppointmentController>(BookAppointmentController(),
        permanent: true);
    Get.put<SelfMonitoringController>(SelfMonitoringController(),
        permanent: true);
    Get.lazyPut(() => UserController(), fenix: true);
  }

  UserController userController = Get.put(UserController());
  BookAppointmentController bookAppointmentController =
      Get.put(BookAppointmentController());
  ScheduledClassController scheduledClassController =
      Get.put(ScheduledClassController());
  DoctorHomeScreenController doctorHomeScreenController =
      Get.put(DoctorHomeScreenController());
  PatientHomeScreenController patientHomeScreenController =
      Get.put(PatientHomeScreenController());
  ServicesDataController servicesDataController =
      Get.put(ServicesDataController());
  RequestController requestController = Get.put(RequestController());
  RoomController roomController = Get.put(RoomController());
  DirectDoctorController directDoctorController =
      Get.put(DirectDoctorController());
  PatientScheduledClassController patientScheduledClassController =
      Get.put(PatientScheduledClassController());
  AdsController adsController = Get.put(AdsController());
  LogOutController logOutController = Get.put(LogOutController());
  ChangeState changeState = Get.put(ChangeState());
}
