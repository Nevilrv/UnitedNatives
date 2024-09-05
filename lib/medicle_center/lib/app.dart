import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/utils/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/app_container.dart';
import 'package:united_natives/medicle_center/lib/blocs/bloc.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';

class App1 extends StatefulWidget {
  const App1({super.key});

  @override
  State<App1> createState() => _App1State();
}

class _App1State extends State<App1> {
  UserController userController = Get.find();
  @override
  void initState() {
    AppBloc.loginCubit.onLogin(
      username: Prefs.getString(Prefs.EMAIL) ?? "",
      password: Prefs.getString(Prefs.PASSWORD) ?? "",
    );
    AppBloc.applicationCubit.onSetup();
    super.initState();
  }

  @override
  void dispose() {
    // AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: BlocListener<MessageCubit, String>(
          listener: (context, message) {
            if (message.isNotEmpty) {
              final snackBar = SnackBar(
                content: Text(Translate.of(context)!.translate(message)),
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
    );
  }
}
