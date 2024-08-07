import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/config.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/material.dart';

class DeepLink extends StatefulWidget {
  final DeepLinkModel deeplink;
  const DeepLink({Key key, this.deeplink}) : super(key: key);

  @override
  _DeepLinkState createState() {
    return _DeepLinkState();
  }
}

class _DeepLinkState extends State<DeepLink> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _onProcess();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onNavigate({
    String route,
    Object arguments,
  }) async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: route,
      );
      if (result == null) return;
    }
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  ///On scan
  void _onProcess() async {
    if (widget.deeplink.target.isNotEmpty) {
      if (widget.deeplink.authentication) {
        _onNavigate(
          route: widget.deeplink.target,
          arguments: widget.deeplink.item,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          widget.deeplink.target,
          arguments: widget.deeplink.item,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Utils.circular(),
      ),
    );
  }
}
