import 'dart:developer';
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
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class RouteArguments<T> {
  final T? item;
  final VoidCallback? callback;
  RouteArguments({this.item, this.callback});
}

class Routes {
  static const String home = "/home";
  static const String discovery = "/discovery";
  static const String wishList = "/wishList";
  static const String account = "/account";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String forgotPassword = "/forgotPassword";
  static const String productDetail = "/productDetail";
  static const String searchHistory = "/searchHistory";
  static const String category = "/category";
  static const String profile = "/profile";
  static const String submit = "/submit";
  static const String editProfile = "/editProfile";
  static const String changePassword = "/changePassword";
  static const String changeLanguage = "/changeLanguage";
  static const String contactUs = "/contactUs";
  static const String aboutUs = "/aboutUs";
  static const String gallery = "/gallery";
  static const String themeSetting = "/themeSetting";
  static const String listProduct = "/listProduct";
  static const String listProduct2 = "/listProduct2";
  static const String filterSubRoute = "/filter_sub_route";
  static const String review = "/review";
  static const String writeReview = "/writeReview";
  static const String setting = "/setting";
  static const String fontSetting = "/fontSetting";
  static const String picker = "/picker";
  static const String galleryUpload = "/galleryUpload";
  static const String categoryPicker = "/categoryPicker";
  static const String gpsPicker = "/gpsPicker";
  static const String submitSuccess = "/submitSuccess";
  static const String openTime = "/openTime";
  static const String socialNetwork = "/socialNetwork";
  static const String tagsPicker = "/tagsPicker";
  static const String webView = "/webView";
  static const String booking = "/booking";
  static const String bookingManagement = "/bookingManagement";
  static const String bookingDetail = "/bookingDetail";
  static const String scanQR = "/scanQR";
  static const String deepLink = "/deepLink";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn(from: settings.arguments as String);
          },
          fullscreenDialog: true,
        );

      case signUp:
        return MaterialPageRoute(
          builder: (context) {
            return const SignUp();
          },
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ForgotPassword();
          },
        );

      case productDetail:
        return MaterialPageRoute(
          builder: (context) {
            return ProductDetail(item: settings.arguments as ProductModel);
          },
        );

      case searchHistory:
        return MaterialPageRoute(
          builder: (context) {
            return const SearchHistory();
          },
          fullscreenDialog: true,
        );

      case category:
        return MaterialPageRoute(
          builder: (context) {
            return Category(item: settings.arguments as CategoryModel);
          },
        );

      case profile:
        return MaterialPageRoute(
          builder: (context) {
            return Profile(user: settings.arguments as UserModel);
          },
        );

      case submit:
        return MaterialPageRoute(
          builder: (context) {
            return Submit(item: settings.arguments as ProductModel);
          },
          fullscreenDialog: true,
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfile();
          },
        );

      case changePassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ChangePassword();
          },
        );

      case changeLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return const LanguageSetting();
          },
        );

      case themeSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const ThemeSetting();
          },
        );

      case filterSubRoute:
        return MaterialPageRoute(
          builder: (context) {
            return Filter(filter: settings.arguments as FilterModel);
          },
          fullscreenDialog: true,
        );

      case review:
        return MaterialPageRoute(
          builder: (context) {
            return Review(product: settings.arguments as ProductModel);
          },
        );

      case setting:
        return MaterialPageRoute(
          builder: (context) {
            return const Setting();
          },
        );

      case fontSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const FontSetting();
          },
        );

      case writeReview:
        return MaterialPageRoute(
          builder: (context) => WriteReview(
            product: settings.arguments as ProductModel,
          ),
        );

      case listProduct:
        return MaterialPageRoute(
          builder: (context) {
            log('category------>');
            return ListProduct(category: settings.arguments as CategoryModel);
          },
        );

      case gallery:
        return MaterialPageRoute(
          builder: (context) {
            return Gallery(product: settings.arguments as ProductModel);
          },
          fullscreenDialog: true,
        );

      case galleryUpload:
        return MaterialPageRoute(
          builder: (context) {
            return GalleryUpload(
              images: settings.arguments as List<ImageModel>,
            );
          },
          fullscreenDialog: true,
        );

      case categoryPicker:
        return MaterialPageRoute(
          builder: (context) {
            return CategoryPicker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case gpsPicker:
        return MaterialPageRoute(
          builder: (context) {
            return GPSPicker(
              picked: settings.arguments as LocationData,
            );
          },
          fullscreenDialog: true,
        );

      case picker:
        return MaterialPageRoute(
          builder: (context) {
            return Picker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case openTime:
        return MaterialPageRoute(
          builder: (context) {
            List<OpenTimeModel>? arguments;
            if (settings.arguments != null) {
              arguments = settings.arguments as List<OpenTimeModel>;
            }
            return OpenTime(
              selected: arguments!,
            );
          },
          fullscreenDialog: true,
        );

      case socialNetwork:
        return MaterialPageRoute(
          builder: (context) {
            return SocialNetwork(
              socials: settings.arguments as Map<String, dynamic>,
            );
          },
          fullscreenDialog: true,
        );

      case submitSuccess:
        return MaterialPageRoute(
          builder: (context) {
            return const SubmitSuccess();
          },
          fullscreenDialog: true,
        );

      case tagsPicker:
        return MaterialPageRoute(
          builder: (context) {
            return TagsPicker(
              selected: settings.arguments as List<String>,
            );
          },
          fullscreenDialog: true,
        );

      case webView:
        return MaterialPageRoute(
          builder: (context) {
            return Web(
              web: settings.arguments as WebViewModel,
            );
          },
          fullscreenDialog: true,
        );

      case booking:
        return MaterialPageRoute(
          builder: (context) {
            return Booking(
              id: settings.arguments as int,
            );
          },
        );

      case bookingManagement:
        return MaterialPageRoute(
          builder: (context) {
            return const BookingManagement();
          },
        );

      case bookingDetail:
        return MaterialPageRoute(
          builder: (context) {
            return BookingDetail(
              item: settings.arguments as BookingItemModel,
            );
          },
        );

      case scanQR:
        return MaterialPageRoute(
          builder: (context) {
            return const ScanQR();
          },
        );

      case deepLink:
        return MaterialPageRoute(
          builder: (context) {
            return DeepLink(
              deeplink: settings.arguments as DeepLinkModel,
            );
          },
        );

      default:
        if (settings.name != null && settings.name!.contains('?type=')) {
          final deeplink = DeepLinkModel.fromString(settings.name!);
          if (deeplink.target!.isNotEmpty) {
            return MaterialPageRoute(
              builder: (context) {
                return DeepLink(deeplink: deeplink);
              },
            );
          }
        }

        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: Utils.circular(),
              ),
            );
          },
          fullscreenDialog: true,
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
