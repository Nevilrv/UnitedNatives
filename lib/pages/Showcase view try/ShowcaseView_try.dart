import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:united_natives/pages/login/login_page_auth.dart';
import '../../components/visited_doctor_list_item.dart';
import '../../data/pref_manager.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../home/widgets/widgets.dart';
import 'package:badges/badges.dart' as badges;

class ShowcaseTry extends StatefulWidget {
  const ShowcaseTry({super.key});

  @override
  State<ShowcaseTry> createState() => _ShowcaseTryState();
}

class _ShowcaseTryState extends State<ShowcaseTry> {
  final bool _noAppoints = false;
  final bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          badges.Badge(
                            badgeStyle: BadgeStyle(
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(2),
                              padding: const EdgeInsets.all(4),
                            ),
                            badgeAnimation: const BadgeAnimation.fade(),
                            position: BadgePosition.topEnd(top: -25, end: -50),
                            badgeContent: const Text(
                              'Menu',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: const Icon(
                              Icons.menu,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 90),
                          _isdark
                              ? Image.asset(
                                  'assets/images/neww_b_Logo.png',
                                  width: 35.0,
                                  height: 35.0,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'assets/images/neww_w_Logo.png',
                                  width: 35.0,
                                  height: 35.0,
                                  fit: BoxFit.fill,
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'United ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Natives',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 70),
                          badges.Badge(
                            badgeStyle: BadgeStyle(
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(2),
                              padding: const EdgeInsets.all(4),
                            ),
                            badgeAnimation: const BadgeAnimation.fade(
                              animationDuration: Duration(milliseconds: 3000),
                            ),
                            position: BadgePosition.topEnd(top: -25, end: 0),
                            badgeContent: const Text(
                              'Notification',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPageA(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Image.asset('assets/images/hand.png'),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${'hello'} ,',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const Text(
                                'how_are_you_today',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_noAppoints)
                      NoAppointmentsWidget()
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                const SectionHeaderWidget(
                                  title: 'next_appointment',
                                ),
                                const NextAppointmentWidget(),
                                SectionHeaderWidget(
                                  title: Translate.of(context)!
                                      .translate('Providers you have visited'),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(Routes.myDoctors),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 15,
                              ),
                              itemCount: 4,
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemBuilder: (context, index) {
                                return VisitedDoctorListItem(
                                  doctor: null,
                                  // doctor: doctors[index],
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 50,
                                ),
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        badges.Badge(
                                          badgeAnimation:
                                              const BadgeAnimation.fade(
                                                  animationDuration: Duration(
                                                      milliseconds: 4000)),
                                          badgeStyle: BadgeStyle(
                                            shape: BadgeShape.square,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          position: BadgePosition.topEnd(
                                              top: -25, end: 0),
                                          badgeContent: const Text(
                                            'Home',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.home,
                                                size: 40,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 80),
                                        badges.Badge(
                                          badgeStyle: BadgeStyle(
                                            shape: BadgeShape.square,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          badgeAnimation:
                                              const BadgeAnimation.fade(
                                            animationDuration:
                                                Duration(milliseconds: 5000),
                                          ),
                                          position: BadgePosition.topEnd(
                                              top: -25, end: 0),
                                          badgeContent: const Text(
                                            'Profile',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Icon(Icons.person_rounded,
                                                size: 40, color: Colors.grey),
                                          ),
                                        ),
                                        const SizedBox(width: 130),
                                        badges.Badge(
                                          badgeAnimation:
                                              const BadgeAnimation.fade(
                                            animationDuration:
                                                Duration(milliseconds: 6000),
                                          ),
                                          badgeStyle: BadgeStyle(
                                            shape: BadgeShape.square,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          position: BadgePosition.topEnd(
                                              top: -30, end: -55),
                                          badgeContent: const Text(
                                            'Message 1',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Icon(Icons.message,
                                                size: 40, color: Colors.grey),
                                          ),
                                        ),
                                        const SizedBox(width: 70),
                                        badges.Badge(
                                          badgeAnimation:
                                              const BadgeAnimation.fade(
                                            animationDuration:
                                                Duration(milliseconds: 7000),
                                          ),
                                          badgeStyle: BadgeStyle(
                                            shape: BadgeShape.square,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          position: BadgePosition.topEnd(
                                              top: -30, end: -50),
                                          badgeContent: const Text(
                                            'Settings ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Icon(Icons.settings,
                                                size: 40, color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: badges.Badge(
        badgeStyle: BadgeStyle(
          shape: BadgeShape.square,
          borderRadius: BorderRadius.circular(5),
          padding: const EdgeInsets.all(4),
        ),
        badgeAnimation: const BadgeAnimation.fade(
          animationDuration: Duration(milliseconds: 8000),
        ),
        position: BadgePosition.topEnd(top: 730, end: -54),
        badgeContent: const Text(
          'Book appointment',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x202e83f8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kColorBlue,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class Mail {
  String sender;
  String sub;
  String msg;
  String date;
  bool isUnread;

  Mail({
    required this.sender,
    required this.sub,
    required this.msg,
    required this.date,
    required this.isUnread,
  });
}

class MailTile extends StatelessWidget {
  final Mail mail;

  const MailTile(this.mail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[200],
                  ),
                  child: Center(
                    child: Text(mail.sender[0]),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mail.sender,
                      style: TextStyle(
                        fontWeight:
                            mail.isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      mail.sub,
                      style: TextStyle(
                        fontWeight:
                            mail.isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      mail.msg,
                      style: TextStyle(
                        fontWeight:
                            mail.isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                mail.date,
                style: TextStyle(
                  fontWeight:
                      mail.isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Icon(
                Icons.star_border,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
