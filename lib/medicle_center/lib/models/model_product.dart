import 'package:united_natives/medicle_center/lib/models/model_category.dart';
import 'package:united_natives/medicle_center/lib/models/model_file.dart';
import 'package:united_natives/medicle_center/lib/models/model_image.dart';
import 'package:united_natives/medicle_center/lib/models/model_open_time.dart';
import 'package:united_natives/medicle_center/lib/models/model_setting.dart';
import 'package:united_natives/medicle_center/lib/models/model_user.dart';
import 'package:location/location.dart';

class ProductModel {
  final int? id;
  final String? title;
  final ImageModel? image;
  final String? videoURL;
  final CategoryModel? category;
  final String? createDate;
  final String? dateEstablish;
  final double? rate;
  final num? numRate;
  final String? rateText;
  final String? status;
  bool? favorite;
  final String? address;
  final String? zipCode;
  final String? phone;
  final String? fax;
  final String? email;
  final String? website;
  final String? description;
  final String? color;
  final String? icon;
  final List<CategoryModel>? tags;
  final String? price;
  final String? priceMin;
  final String? priceMax;
  final CategoryModel? country;
  final CategoryModel? city;
  final CategoryModel? state;
  final UserModel? author;
  final List<ImageModel>? galleries;
  final List<CategoryModel>? features;
  final List<ProductModel>? related;
  final List<ProductModel>? latest;
  final List<OpenTimeModel>? openHours;
  final Map<String, dynamic>? socials;
  final List<FileModel>? attachments;
  final LocationData? location;
  final String? link;
  final bool? bookingUse;
  final String? bookingStyle;
  final String? priceDisplay;
  final String? countryName;
  final String? stateName;
  final String? cityName;

  ProductModel({
    this.id,
    this.title,
    this.image,
    this.videoURL,
    this.category,
    this.createDate,
    this.dateEstablish,
    this.rate,
    this.numRate,
    this.rateText,
    this.status,
    this.favorite,
    this.address,
    this.zipCode,
    this.phone,
    this.fax,
    this.email,
    this.website,
    this.description,
    this.color,
    this.icon,
    this.tags,
    this.price,
    this.priceMin,
    this.priceMax,
    this.country,
    this.city,
    this.state,
    this.author,
    this.galleries,
    this.features,
    this.related,
    this.latest,
    this.openHours,
    this.socials,
    this.location,
    this.attachments,
    this.link,
    this.bookingUse,
    this.bookingStyle,
    this.priceDisplay,
    this.countryName,
    this.stateName,
    this.cityName,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    SettingModel? setting,
  }) {
    List<ImageModel> galleries = [];
    List<CategoryModel> features = [];
    List<OpenTimeModel> openHours = [];
    List<FileModel> attachments = [];
    List<CategoryModel> tags = [];
    Map<String, dynamic> socials = {};
    UserModel? author;
    CategoryModel? category;
    LocationData? location;
    CategoryModel? country;
    CategoryModel? state;
    CategoryModel? city;
    String status = '';
    String videoURL = '';
    String address = '';
    String phone = '';
    String email = '';
    String website = '';
    String dateEstablish = '';
    String priceMin = '';
    String priceMax = '';
    String priceDisplay = '';
    // String countryName = '';
    // String stateName = '';
    // String cityName = '';

    if (json['author'] != null) {
      author = UserModel.fromJson(json['author']);
    }

    if (json['category'] != null) {
      category = CategoryModel.fromJson(json['category']);
    }

    if (json['location'] != null && json['location']['country'] != null) {
      country = CategoryModel.fromJson(json['location']['country']);
    }

    if (json['location'] != null && json['location']['state'] != null) {
      state = CategoryModel.fromJson(json['location']['state']);
    }

    if (json['location'] != null && json['location']['city'] != null) {
      city = CategoryModel.fromJson(json['location']['city']);
    }

    if (json['latitude'] != null && setting?.useViewMap == true) {
      location = LocationData.fromMap({
        'isMock': 0,
        "longitude": double.tryParse(json['longitude']),
        "latitude": double.tryParse(json['latitude']),
      });
    }

    if (setting?.useViewGalleries == true) {
      galleries = List.from(json['galleries'] ?? []).map((item) {
        return ImageModel.fromJson(item);
      }).toList();
    }

    if (setting?.useViewStatus == true) {
      status = json['status'] ?? '';
    }

    if (setting?.useViewVideo == true) {
      videoURL = json['video_url'] ?? '';
    }

    if (setting?.useViewAddress == true) {
      address = json['address'] ?? '';
    }

    if (setting?.useViewPhone == true) {
      phone = json['phone'] ?? '';
    }

    if (setting?.useViewEmail == true) {
      email = json['email'] ?? '';
    }

    if (setting?.useViewWebsite == true) {
      website = json['website'] ?? '';
    }

    if (setting?.useViewDateEstablish == true) {
      dateEstablish = json['date_establish'] ?? '';
    }

    if (setting?.useViewPrice == true) {
      priceMin = json['price_min'] ?? '';
      priceMax = json['price_max'] ?? '';
    }

    if (setting?.useViewFeature == true) {
      features = List.from(json['features'] ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
    }

    final listRelated = List.from(json['related'] ?? []).map((item) {
      return ProductModel.fromJson(item, setting: setting);
    }).toList();

    final listLatest = List.from(json['lastest'] ?? []).map((item) {
      return ProductModel.fromJson(item, setting: setting);
    }).toList();

    if (setting?.useViewOpenHours == true) {
      openHours = List.from(json['opening_hour'] ?? []).map((item) {
        return OpenTimeModel.fromJson(item);
      }).toList();
    }

    if (setting?.useViewTags == true) {
      tags = List.from(json['tags'] ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
    }

    if (setting?.useViewAttachment == true) {
      attachments = List.from(json['attachments'] ?? []).map((item) {
        return FileModel.fromJson(item);
      }).toList();
    }

    if (setting?.useViewSocial == true &&
        json['social_network'] is Map<String, dynamic>) {
      socials = json['social_network'];
    }

    final bookingUse = json['booking_use'] == true;
    if (bookingUse) {
      priceDisplay = json['booking_price_display'];
    }

    Map<String, dynamic> image = json['image'].runtimeType == String
        ? {
            "id": 222,
            "full": {"url": json['image']},
            "thumb": {"url": json['image']}
          }
        : json['image'];
    return ProductModel(
      id: int.tryParse('${json['ID']}') ?? 0,
      title: json['post_title'] ?? '',
      image: ImageModel.fromJson(image),
      // image: ImageModel.fromJson(json['image'] ?? {'full': {}, 'thumb': {}}),
      videoURL: videoURL,
      category: category,
      createDate: json['post_date'] ?? '',
      dateEstablish: dateEstablish,
      rate: double.tryParse('${json['rating_avg']}') ?? 0.0,
      numRate: json['rating_count'] ?? 0,
      rateText: json['post_status'] ?? '',
      status: status,
      favorite: json['wishlist'] ?? false,
      address: address,
      zipCode: json['zip_code'] ?? '',
      phone: phone,
      fax: json['fax'] ?? '',
      email: email,
      website: website,
      description: json['post_excerpt'] ?? '',
      color: json['color'] ?? '',
      icon: json['icon'] ?? '',
      tags: tags,
      price: json['booking_price'] ?? '',
      priceMin: priceMin,
      priceMax: priceMax,
      country: country,
      state: state,
      city: city,
      features: features,
      author: author,
      galleries: galleries,
      related: listRelated,
      latest: listLatest,
      openHours: openHours,
      socials: socials,
      location: location,
      attachments: attachments,
      link: json['guid'] ?? '',
      bookingUse: bookingUse,
      bookingStyle: json['booking_style'] ?? '',
      priceDisplay: priceDisplay,
      countryName: json['country'] ?? '',
      stateName: json['state'] ?? '',
      cityName: json['city'] ?? '',
    );
  }

  factory ProductModel.fromNotification(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse('${json['ID']}') ?? 0,
      title: json['post_title'] ?? '',
      image: ImageModel.fromJson(json['image'] ?? {'full': {}, 'thumb': {}}),
      videoURL: '',
      createDate: '',
      dateEstablish: '',
      rate: double.tryParse('${json['rating_avg']}') ?? 0.0,
      numRate: 0,
      rateText: '',
      status: '',
      favorite: false,
      address: '',
      zipCode: '',
      phone: '',
      fax: '',
      email: '',
      website: '',
      description: '',
      color: '',
      icon: '',
      tags: [],
      price: '',
      priceMin: '',
      priceMax: '',
      features: [],
      galleries: [],
      related: [],
      latest: [],
      openHours: [],
      socials: {},
      attachments: [],
      link: '',
      bookingUse: false,
      bookingStyle: '',
      priceDisplay: '',
      countryName: '',
      stateName: '',
      cityName: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "post_title": title,
      "image": {
        "id": 0,
        "full": {},
        "thumb": {},
      },
    };
  }
}
