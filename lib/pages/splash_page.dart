import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/blocs/app_bloc.dart';
import 'package:united_natives/medicle_center/lib/blocs/discovery/discovery_cubit.dart';
import 'package:united_natives/medicle_center/lib/blocs/review/review_state.dart';
import 'package:united_natives/medicle_center/lib/blocs/submit/submit_state.dart';
import 'package:united_natives/medicle_center/lib/screens/search_history/search_history.dart';
import 'package:united_natives/sevices/app_notification.dart';
import 'package:united_natives/utils/app_themes.dart';
import 'package:united_natives/utils/utils.dart';

import '../routes/routes.dart';
import '../utils/constants.dart';

List tempList = [];

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  UserController userController = Get.put(UserController());

  @override
  void initState() {
    getAdsData();
    _getMedicalCenterData();
    AppNotificationHandler.getInitialMsg();
    AppNotificationHandler.showMsgHandler();
    AppNotificationHandler.onMsgOpen();
    super.initState();
    Timer(const Duration(seconds: 4), () {
      _savedUserData();
    });
  }

  final _discoveryCubit = DiscoveryCubit();
  late StreamSubscription submitSubscription;
  late StreamSubscription reviewSubscription;
  late SearchHistoryDelegate delegate;

  _getMedicalCenterData() {
    /// MEDICAL CENTER

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppBloc.homeCubit.onLoad();
      _discoveryCubit.onLoad();
      // AppBloc.discoveryCubit.onLoad();

      // if (AppBloc.filterCubit.selectedState == null) {
      AppBloc.filterCubit.onStateLoad();
      // }

      submitSubscription = AppBloc.submitCubit.stream.listen((state) {
        if (state is Submitted) {
          AppBloc.homeCubit.onLoad();
        }
      });
      reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
        if (state is ReviewSuccess && state.id != null) {
          AppBloc.homeCubit.onLoad();
        }
      });
      delegate = SearchHistoryDelegate();
    });
  }

  _savedUserData() async {
    String email = Config.getEmail();
    String loginType = Config.getLoginType();
    String userType = Config.getUserType();
    if (email.isEmpty) {
      _loadScreen();
    } else if (loginType == 'google' && userType == '1') {
      _autoPatientSocialLogin();
    } else if (loginType == 'google' && userType == '2') {
      _autoDoctorSocialLogin();
    } else {
      _autoLogin();
    }
  }

  _autoPatientSocialLogin() async {
    // await Prefs.getString(Prefs.PASSWORD);
    // await Prefs.getString(Prefs.EMAIL);
    await Prefs.load();
    // BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(
    //     theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
    //         ? AppTheme.DarkTheme
    //      : AppTheme.LightTheme));
    setState(() {
      Get.changeTheme(Prefs.getBool(Prefs.DARKTHEME, def: false)
          ? Themes().isDark
          : Themes().isLight);
    });
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.phoneAuthScreen5);
    List s = [1, 2];

    s.join(",");

    Utils.showSnackBar('${Config.getEmail()} successfully login!',
        'Enter your secret PIN to Continue');
  }

  _autoDoctorSocialLogin() async {
    // await Prefs.getString(Prefs.PASSWORD);
    // await Prefs.getString(Prefs.EMAIL);
    await Prefs.load();

    // context.read<ThemeBloc>().add(ThemeChanged(
    //     theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
    //         ? AppTheme.DarkTheme
    //         : AppTheme.LightTheme));
    setState(() {
      Get.changeTheme(Prefs.getBool(Prefs.DARKTHEME, def: false)
          ? Themes().isDark
          : Themes().isLight);
    });

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.phoneAuthScreen7);
    // if (userController.isInitialNotification == true) {
    //   Navigator.of(context)
    //       .pushReplacementNamed(Routes.phoneAuthScreen7)
    //       .then((value) {
    //     Get.to(
    //       MyAppointmentsDoctor(),
    //     );
    //   });
    // } else {
    //   Navigator.of(context).pushReplacementNamed(Routes.phoneAuthScreen7);
    // }

    Utils.showSnackBar('${Config.getEmail()} successfully login!',
        'Enter your secret PIN to Continue');
  }

  _autoLogin() async {
    // await Prefs.getString(Prefs.PASSWORD);
    // await Prefs.getString(Prefs.EMAIL);
    // ThemeBloc bloc=BlocProvider.of<ThemeBloc>(context);
    await Prefs.load();

    // context1.read<ThemeBloc>().add(ThemeChanged(
    //     theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
    //         ? AppTheme.DarkTheme
    //         : AppTheme.LightTheme));
    setState(() {
      Get.changeTheme(Prefs.getBool(Prefs.DARKTHEME, def: false)
          ? Themes().isDark
          : Themes().isLight);
    });
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(Routes.phoneAuthScreen2);
    Utils.showSnackBar('${Config.getEmail()} successfully login!',
        'Enter your secret PIN to Continue');
  }

  _loadScreen() async {
    // ThemeBloc bloc=BlocProvider.of<ThemeBloc>(context);
    await Prefs.load();
    setState(() {
      Get.changeTheme(Prefs.getBool(Prefs.DARKTHEME, def: false)
          ? ThemeData.dark()
          : ThemeData.light());
    });
    // context1.read<ThemeBloc>().add(ThemeChanged(
    //     theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
    //         ? AppTheme.DarkTheme
    //         : AppTheme.LightTheme));

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(Routes.intro);

    // Bloc.observer = AppBlocObserver();
    // Get.to(App1()).then(
    //   (value) => AppBloc.loginCubit.onLogin(
    //     username: Prefs.getString(Prefs.EMAIL),
    //     password: Prefs.getString(Prefs.PASSWORD),
    //   ),
    // );
  }

  Future getAdsData() async {
    http.Response response = await http.get(
      Uri.parse(Constants.baseUrl + Constants.getAllAdvertisement),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      tempList = result['data'];
      return result;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: _isdark?Colors.black:Colors.white,
      body: Container(
        width: double.infinity,
        color: _isDark ? Colors.black : Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _isDark
                          ? Image.asset(
                              'assets/images/neww_b_IH_Logo.png',
                              width: 233,
                              height: 285,
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              'assets/images/neww_w_IH_Logo.png',
                              width: 233,
                              height: 285,
                              fit: BoxFit.fill,
                            ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 150,
              height: 2,
              child: LinearProgressIndicator(
                backgroundColor: kColorBlue,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
