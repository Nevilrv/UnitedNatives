import 'dart:developer';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/app_container.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class App1 extends StatefulWidget {
  const App1({Key key}) : super(key: key);

  @override
  _App1State createState() => _App1State();
}

class _App1State extends State<App1> {
  UserController userController = Get.find();
  @override
  void initState() {
    super.initState();
    log('loading======>');
    AppBloc.loginCubit.onLogin(
      username: Prefs.getString(Prefs.EMAIL),
      password: Prefs.getString(Prefs.PASSWORD),
    );
    AppBloc.applicationCubit.onSetup();
  }

  @override
  void dispose() {
    // AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // _showInterstitialAd();
        Get.back();
        return true;
      },
      child: Scaffold(
        body: BlocListener<MessageCubit, String>(
          listener: (context, message) {
            if (message != null) {
              final snackBar = SnackBar(
                content: Text(Translate.of(context).translate(message)),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: BlocBuilder<ApplicationCubit, ApplicationState>(
            builder: (context, application) {
              if (application == ApplicationState.completed) {
                return const AppContainer();
              }
              if (application == ApplicationState.intro) {
                return const AppContainer();
              }
              return const AppContainer();
            },
          ),
        ),
      ),
      /* MultiBlocProvider(
        providers: AppBloc.providers,
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, lang) {
            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, theme) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme.lightTheme,
                  darkTheme: theme.darkTheme,
                  onGenerateRoute: Routes.generateRoute,
                  locale: lang,
                  localizationsDelegates: [
                    Translate(lang).delegate,
                    // delegate GlobalMaterialLocalizations.delegate,
                    //  GlobalWidgetsLocalizations.delegate,
                    //  GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLanguage.supportLanguage,
                  home: Scaffold(
                    body: BlocListener<MessageCubit, String>(
                      listener: (context, message) {
                        if (message != null) {
                          final snackBar = SnackBar(
                            content: Text(
                              Translate.of(context).translate(message),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: BlocBuilder<ApplicationCubit, ApplicationState>(
                        builder: (context, application) {
                          if (application == ApplicationState.completed) {
                            return const AppContainer();
                          }
                          if (application == ApplicationState.intro) {
                            return const Intro();
                          }
                          return const SplashScreen();
                        },
                      ),
                    ),
                  ),
                  builder: (context, child) {
                    final data = MediaQuery.of(context).copyWith(
                      textScaleFactor: theme.textScaleFactor,
                    );
                    return MediaQuery(
                      data: data,
                      child: child,
                    );
                  },
                );
              },
            );
          },
        ),
      ),*/
    );
  }
}
