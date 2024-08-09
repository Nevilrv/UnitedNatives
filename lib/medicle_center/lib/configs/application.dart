import 'package:united_natives/medicle_center/lib/models/model.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Application {
  static bool debug = true;
  static String domain = Constants.domain;
  // static String domain = 'https://medicalcenter.sataware.dev';
  // static String domain = 'https://unhbackend.sataware.dev/wordpress';
  static DeviceModel? device;
  static PackageInfo? packageInfo;
  static SettingModel setting = SettingModel.fromDefault();

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
