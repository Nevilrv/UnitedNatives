// import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/configs/config.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/screens/screen.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class AppContainer extends StatefulWidget {
//   const AppContainer({Key key}) : super(key: key);
//
//   @override
//   _AppContainerState createState() {
//     return _AppContainerState();
//   }
// }
//
// class _AppContainerState extends State<AppContainer> {
//   String _selected = Routes.home;
//   SearchHistoryDelegate _delegate;
//   @override
//   void initState() {
//     super.initState();
//     FirebaseMessaging.onMessage.listen((message) {
//       _notificationHandle(message);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _notificationHandle(message);
//     });
//     _delegate = SearchHistoryDelegate();
//   }
//
//   ///check route need auth
//   bool _requireAuth(String route) {
//     switch (route) {
//       case Routes.home:
//       case Routes.discovery:
//         return false;
//       default:
//         return true;
//     }
//   }
//
//   ///Export index stack
//   int _exportIndexed(String route) {
//     switch (route) {
//       case Routes.home:
//         return 0;
//       case Routes.discovery:
//         return 1;
//       case Routes.wishList:
//         return 2;
//       case Routes.account:
//         return 3;
//       default:
//         return 0;
//     }
//   }
//
//   ///Handle When Press Notification
//   void _notificationHandle(RemoteMessage message) {
//     final notification = NotificationModel.fromJson(message);
//     if (notification.target != null) {
//       Navigator.pushNamed(
//         context,
//         notification.target,
//         arguments: notification.item,
//       );
//     }
//   }
//
//   ///Force switch home when authentication state change
//   void _listenAuthenticateChange(AuthenticationState authentication) async {
//     if (authentication == AuthenticationState.fail && _requireAuth(_selected)) {
//       final result = await Navigator.pushNamed(
//         context,
//         Routes.signIn,
//         arguments: _selected,
//       );
//       if (result != null) {
//         setState(() {
//           _selected = result as String;
//         });
//       } else {
//         setState(() {
//           _selected = Routes.home;
//         });
//       }
//     }
//   }
//
//   ///On change tab bottom menu and handle when not yet authenticate
//   void _onItemTapped(String route) async {
//     setState(() {});
//     // log('AppBloc.userCubit.state----${AppBloc.userCubit.state.name}');
//     if (AppBloc.userCubit.state == null && _requireAuth(route)) {
//       final result = await Navigator.pushNamed(
//         context,
//         Routes.signIn,
//         arguments: route,
//       );
//       if (result == null) return;
//     }
//     setState(() {
//       _selected = route;
//     });
//   }
//
//   ///On handle submit post
//   void _onSubmit() async {
//     if (AppBloc.userCubit.state == null) {
//       final result = await Navigator.pushNamed(
//         context,
//         Routes.signIn,
//         arguments: Routes.submit,
//       );
//       if (result == null) return;
//     }
//     if (!mounted) return;
//     _onSearch1();
//     // Navigator.pushNamed(context, Routes.searchHistory);
//   }
//
//   ///onShow search
//   void _onSearch1() async {
//     AppBloc.searchCubit.onClear();
//     await showSearch(
//       context: context,
//       delegate: _delegate,
//     );
//   }
//
//   ///Build Item Menu
//   Widget _buildMenuItem(String route) {
//     Color color;
//     String title = 'home';
//     IconData iconData = Icons.help_outline;
//     switch (route) {
//       case Routes.home:
//         iconData = Icons.home_outlined;
//         title = 'home';
//         break;
//       case Routes.discovery:
//         iconData = Icons.location_on_outlined;
//         title = 'discovery';
//         break;
//       case Routes.wishList:
//         iconData = Icons.bookmark_outline;
//         title = 'wish_list';
//         break;
//       case Routes.account:
//         iconData = Icons.account_circle_outlined;
//         title = 'account';
//         break;
//       default:
//         iconData = Icons.home_outlined;
//         title = 'home';
//         break;
//     }
//     if (route == _selected) {
//       color = Theme.of(context).primaryColor;
//     }
//     return IconButton(
//       onPressed: () {
//         _onItemTapped(route);
//       },
//       padding: EdgeInsets.zero,
//       icon: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             iconData,
//             color: color,
//           ),
//           const SizedBox(height: 2),
//           Text(
//             Translate.of(context).translate(title),
//             style: Theme.of(context).textTheme.button.copyWith(
//                   fontSize: 10,
//                   color: color,
//                 ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           )
//         ],
//       ),
//     );
//   }
//
//   ///Build submit button
//   Widget _buildSubmit() {
//     if (Application.setting.enableSubmit) {
//       return FloatingActionButton(
//         backgroundColor: Theme.of(context).primaryColor,
//         onPressed: _onSubmit,
//         child: const Icon(
//           Icons.search,
//           color: Colors.white,
//         ),
//       );
//     }
//     return null;
//   }
//
//   ///Build bottom menu
//   Widget _buildBottomMenu() {
//     if (Application.setting.enableSubmit) {
//       return BottomAppBar(
//         child: SizedBox(
//           height: 56,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildMenuItem(Routes.home),
//               _buildMenuItem(Routes.discovery),
//               const SizedBox(width: 56),
//               _buildMenuItem(Routes.wishList),
//               _buildMenuItem(Routes.account),
//             ],
//           ),
//         ),
//       );
//     }
//     return BottomAppBar(
//       child: SizedBox(
//         height: 56,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildMenuItem(Routes.home),
//             _buildMenuItem(Routes.discovery),
//             _buildMenuItem(Routes.wishList),
//             _buildMenuItem(Routes.account),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const submitPosition = FloatingActionButtonLocation.centerDocked;
//     return Scaffold(
//       body: BlocListener<AuthenticationCubit, AuthenticationState>(
//         listener: (context, authentication) async {
//           _listenAuthenticateChange(authentication);
//         },
//         child: IndexedStack(
//           index: _exportIndexed(_selected),
//           children: const <Widget>[Home(), Discovery(), WishList(), Account()],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomMenu(),
//       floatingActionButton: _buildSubmit(),
//       floatingActionButtonLocation: submitPosition,
//     );
//   }
// }

import 'package:doctor_appointment_booking/medicle_center/lib/blocs/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/config.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/screens/screen.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({Key key}) : super(key: key);

  @override
  _AppContainerState createState() {
    return _AppContainerState();
  }
}

class _AppContainerState extends State<AppContainer> {
  String _selected = Routes.home;
  SearchHistoryDelegate _delegate;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      _notificationHandle(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _notificationHandle(message);
    });
    _delegate = SearchHistoryDelegate();
  }

  ///check route need auth
  bool _requireAuth(String route) {
    switch (route) {
      case Routes.home:
      case Routes.discovery:
        return false;
      default:
        return true;
    }
  }

  ///Export index stack
  int _exportIndexed(String route) {
    switch (route) {
      case Routes.home:
        return 0;
      case Routes.discovery:
        return 1;
      case Routes.discovery:
        return 2;
      case Routes.wishList:
        return 3;
      default:
        return 0;
    }
  }

  ///Handle When Press Notification
  void _notificationHandle(RemoteMessage message) {
    final notification = NotificationModel.fromJson(message);
    if (notification.target != null) {
      Navigator.pushNamed(
        context,
        notification.target,
        arguments: notification.item,
      );
    }
  }

  ///Force switch home when authentication state change
  void _listenAuthenticateChange(AuthenticationState authentication) async {
    print('11==authentication===>$authentication');
    print('22==authentication===>${AuthenticationState.fail}');
    print('33==authentication===>${_requireAuth(_selected)}');
    print('44==authentication===>$_selected');

    if (authentication == AuthenticationState.fail && _requireAuth(_selected)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: _selected,
      );
      if (result != null) {
        setState(() {
          _selected = result as String;
        });
      } else {
        setState(() {
          _selected = Routes.home;
        });
      }
    }
  }

  ///On change tab bottom menu and handle when not yet authenticate
  void _onItemTapped(String route) async {
    setState(() {});

    if (AppBloc.userCubit.state == null && _requireAuth(route)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: route,
      );
      if (result == null) return;
    }
    setState(() {
      _selected = route;
    });
  }

  ///On handle submit post
  void _onSubmit() async {
    if (AppBloc.userCubit.state == null) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.submit,
      );
      if (result == null) return;
    }
    if (!mounted) return;
    _onSearch1();
  }

  ///onShow search
  void _onSearch1() async {
    AppBloc.searchCubit.onClear();
    await showSearch(
      context: context,
      delegate: _delegate,
    );
  }

  ///Build Item Menu
  Widget _buildMenuItem(String route) {
    Color color;
    String title = 'home';
    IconData iconData = Icons.help_outline;
    switch (route) {
      case Routes.home:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
      case '1':
        iconData = Icons.search;
        title = 'search';
        break;
      case Routes.discovery:
        iconData = Icons.location_on_outlined;
        title = 'Discovery';
        break;
      case Routes.wishList:
        iconData = Icons.bookmark_outline;
        title = 'Wish List';
        break;
      default:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
    }
    if (route == _selected) {
      color = Theme.of(context).primaryColor;
    }
    return GestureDetector(
      onTap: () {
        _onItemTapped(route);
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: color,
              ),
              const SizedBox(height: 2),
              Text(
                Translate.of(context).translate(title),
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 12,
                      color: color,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Build submit button
  Widget _buildSubmit() {
    if (Application.setting.enableSubmit) {
      return GestureDetector(
        onTap: _onSubmit,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search,
              ),
              Text(
                'Search',
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 12,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      );
    }
    return null;
  }

  ///Build bottom menu
  Widget _buildBottomMenu() {
    if (Application.setting.enableSubmit) {
      return BottomAppBar(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMenuItem(Routes.home),
              _buildSubmit(),
              _buildMenuItem(Routes.discovery),
              _buildMenuItem(Routes.wishList),
            ],
          ),
        ),
      );
    }
    return BottomAppBar(
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMenuItem(Routes.home),
            _buildSubmit(),
            _buildMenuItem(Routes.discovery),
            _buildMenuItem(Routes.wishList),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, authentication) async {
          _listenAuthenticateChange(authentication);
        },
        child: IndexedStack(
          index: _exportIndexed(_selected),
          children: <Widget>[
            Home(),
            Discovery(),
            Discovery(),
            WishList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomMenu(),
    );
  }
}
