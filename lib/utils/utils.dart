import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:united_natives/data/pref_manager.dart';

import 'constants.dart';

class Utils {
  static void showSnackBar(String title, message) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.showSnackbar(
        GetSnackBar(
          title: title,
          message: message ?? "",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          borderRadius: 8,
          backgroundColor:
              isDark ? Colors.grey.withOpacity(0.25) : Colors.black45,
          duration: const Duration(seconds: 2),
          animationDuration: const Duration(milliseconds: 500),
          barBlur: 10,
        ),
      );
      /*Get.snackbar(
        title,
        message ?? '',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        borderRadius: 8,
        backgroundColor: Colors.black45,
        animationDuration: Duration(milliseconds: 500),
        barBlur: 10,
        colorText: Colors.white,
      );*/
    });
  }

  static String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  static void showSnackBarMesgDeleted(
      {required String title, required String msg}) {
    Get.showSnackbar(GetSnackBar(
      snackStyle: SnackStyle.FLOATING,
      title: title,
      message: msg,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      borderRadius: 8,
      backgroundColor: Colors.black45,
      duration: const Duration(seconds: 1),
      animationDuration: const Duration(milliseconds: 500),
      barBlur: 10,
    ));
    /*  Get.snackbar(
        title,
        message ?? '',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        borderRadius: 8,
        backgroundColor: Colors.black45,
        animationDuration: Duration(milliseconds: 500),
        barBlur: 10,
        colorText: Colors.white,
      );*/
  }

  static DateTime formattedDate(String date) {
    String utcTimeString = date;
    DateTime utcTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parseUtc(utcTimeString);
    DateTime localTime = utcTime.toLocal();
    return localTime;
  }

  // final UserController _userController = Get.find();

  Widget patientProfile(String profileImage, String socialImage, double radius,
      {BoxFit? fit}) {
    RxString imagePath = "".obs;

    if (profileImage.isNotEmpty) {
      imagePath(profileImage);
    } else if (socialImage.isNotEmpty) {
      imagePath(socialImage);
    } else {
      imagePath("");
    }

    return Obx(
      () => (imagePath.isNotEmpty)
          ? CircleAvatar(
              radius: radius,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: OctoImage(
                  image: CachedNetworkImageProvider(
                    imagePath.value,
                  ),
                  // placeholderBuilder: OctoPlaceholder.blurHash(
                  //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  // ),

                  progressIndicatorBuilder: (context, progress) {
                    double? value;
                    var expectedBytes = progress?.expectedTotalBytes;
                    if (progress != null && expectedBytes != null) {
                      value = progress.cumulativeBytesLoaded / expectedBytes;
                    }
                    return CircularProgressIndicator(value: value);
                  },
                  errorBuilder: OctoError.circleAvatar(
                    backgroundColor: Colors.white,
                    text: Image.network(
                      'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                      color: const Color(0xFF7E7D7D),
                      // 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                    ),
                  ),
                  fit: fit ?? BoxFit.fill,
                  height: Get.height,
                  width: Get.height,
                ),
              ),
            ) /*CircleAvatar(
        radius: radious,
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage("${profileImage ?? "https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png"}"),
        onBackgroundImageError: (context, error) {
          return Container();
        },
      )*/
          : CircleAvatar(
              radius: radius,
              backgroundColor: Colors.white,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: OctoImage(
                  image: const CachedNetworkImageProvider(
                    'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                    // 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                  ),
                  // placeholderBuilder: OctoPlaceholder.blurHash(
                  //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  // ),

                  progressIndicatorBuilder: (context, progress) {
                    double? value;
                    var expectedBytes = progress?.expectedTotalBytes;
                    if (progress != null && expectedBytes != null) {
                      value = progress.cumulativeBytesLoaded / expectedBytes;
                    }
                    return CircularProgressIndicator(value: value);
                  },

                  errorBuilder: OctoError.circleAvatar(
                    backgroundColor: Colors.white,
                    text: Image.network(
                      'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                      // 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                    ),
                  ),
                  color: const Color(0xFF7E7D7D),
                  fit: fit ?? BoxFit.fill,
                  height: Get.height,
                  width: Get.height,
                ),
              ),
            ),
    );
  }

  Widget imageProfile(String profileImage, double radius) {
    RxString imagePath = "".obs;
    if (profileImage.isNotEmpty) {
      imagePath(profileImage);
    } else {
      imagePath("");
    }

    return Obx(
      () => (imagePath.isNotEmpty)
          ? /*CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage("${profileImage ?? ""}"),
              onBackgroundImageError: (context, error) {
                return Container();
              },
            )*/
          CircleAvatar(
              radius: radius,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: OctoImage(
                  image: CachedNetworkImageProvider(profileImage),
                  // placeholderBuilder: OctoPlaceholder.blurHash(
                  //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  // ),
                  progressIndicatorBuilder: (context, progress) {
                    double? value;
                    var expectedBytes = progress?.expectedTotalBytes;
                    if (progress != null && expectedBytes != null) {
                      value = progress.cumulativeBytesLoaded / expectedBytes;
                    }
                    return CircularProgressIndicator(value: value);
                  },
                  errorBuilder: OctoError.circleAvatar(
                      backgroundColor: Colors.white,
                      text: Image.network(
                        'https://cdn-icons-png.flaticon.com/128/666/666201.png',
                        color: const Color(0xFF7E7D7D),
                        // 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png',
                      )),
                  fit: BoxFit.fill,
                  height: Get.height,
                  width: Get.height,
                ),
              ),
            )
          : CircleAvatar(
              radius: radius,
              backgroundColor: Colors.white,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: OctoImage(
                  image: const CachedNetworkImageProvider(
                      'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                  // placeholderBuilder: OctoPlaceholder.blurHash(
                  //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  // ),
                  progressIndicatorBuilder: (context, progress) {
                    double? value;
                    var expectedBytes = progress?.expectedTotalBytes;
                    if (progress != null && expectedBytes != null) {
                      value = progress.cumulativeBytesLoaded / expectedBytes;
                    }
                    return CircularProgressIndicator(value: value);
                  },
                  errorBuilder: OctoError.circleAvatar(
                      backgroundColor: Colors.white,
                      text: Image.network(
                          'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png')),
                  fit: BoxFit.fill,
                  height: Get.height,
                  width: Get.height,
                ),
              ),
            ),
    );
  }

  Widget imageProfileFromLocal(String profileImage, double radius) {
    RxString imagePath = "".obs;
    if (profileImage.isNotEmpty) {
      imagePath(profileImage);
    } else {
      imagePath("");
    }

    return Obx(
      () => (imagePath.isNotEmpty)
          ? /*CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage("${profileImage ?? ""}"),
              onBackgroundImageError: (context, error) {
                return Container();
              },
            )*/
          CircleAvatar(
              radius: radius,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: Image(
                  image: AssetImage(imagePath.value),
                ),

                // OctoImage(
                //   image: CachedNetworkImageProvider(profileImage ??
                //       'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                //   placeholderBuilder: OctoPlaceholder.blurHash(
                //     'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                //     // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                //   ),
                //   errorBuilder: OctoError.circleAvatar(
                //       backgroundColor: Colors.white,
                //       text: Image.network(
                //           'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png')),
                //   fit: BoxFit.fill,
                //   height: Get.height,
                //   width: Get.height,
                // ),
              ),
            )
          : CircleAvatar(
              radius: radius,
              backgroundColor: Colors.white,
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: OctoImage(
                  image: const CachedNetworkImageProvider(
                      'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'),
                  // placeholderBuilder: OctoPlaceholder.blurHash(
                  //   'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  //   // 'LUN0}3j@~qof-;j[j[f6?bj[D%ay',
                  // ),

                  progressIndicatorBuilder: (context, progress) {
                    double? value;
                    var expectedBytes = progress?.expectedTotalBytes;
                    if (progress != null && expectedBytes != null) {
                      value = progress.cumulativeBytesLoaded / expectedBytes;
                    }
                    return CircularProgressIndicator(value: value);
                  },

                  errorBuilder: OctoError.circleAvatar(
                      backgroundColor: Colors.white,
                      text: Image.network(
                          'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png')),
                  fit: BoxFit.fill,
                  height: Get.height,
                  width: Get.height,
                ),
              ),
            ),
    );
  }

  static Container loadingBar() {
    return Container(
      color: Colors.black26,
      child: /*Center(
        child: CircularProgressIndicator(),
      )*/
          Center(
        child: Utils.circular(),
      ),
    );
  }

  static circular({
    bool isContainer = false,
    double height = 65,
  }) {
    // return Center(
    //   child: Image.asset(
    //     "assets/images/loader.png",
    //     height: height,
    //     width: width,
    //   ),
    // );

    return SpinKitWaveSpinner(
      size: height,
      color: kColorBlue,
      waveColor: kColorBlue,
    );

    // return CircularProgressIndicator();
  }

  static Future<String> selectedDateFormat(context,
      {DateTime? selectedDate}) async {
    final time = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: selectedDate ?? DateTime.now(),
        lastDate: DateTime(2100));

    if (time != null) {
      return DateFormat('dd-MM-yyyy').format(time);
    } else if (selectedDate != null) {
      return DateFormat('dd-MM-yyyy').format(selectedDate);
    } else {
      return '';
    }
  }
}

class Config {
  static Map<String, String> getHeaders() {
    return {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      "Content-Type": 'application/json',
    };
  }

  static String getEmail() {
    return Prefs.getString(Prefs.EMAIL) ?? "";
  }

  static String getPassword() {
    return Prefs.getString(Prefs.PASSWORD) ?? "";
  }

  static String getUserType() {
    return Prefs.getString(Prefs.USERTYPE) ?? "";
  }

  static String getLoginType() {
    return Prefs.getString(Prefs.LOGINTYPE) ?? "";
  }

  static String getSocialID() {
    return Prefs.getString(Prefs.SOCIALID) ?? "";
  }

  static String getIsAdmin() {
    return Prefs.getString(Prefs.IsAdmin) ?? "";
  }

  static String getProfileImage() {
    return Prefs.getString(Prefs.profileImage) ?? "";
  }
}
