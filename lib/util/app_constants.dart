import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:aitek/helper/domain_helper.dart';
import 'package:aitek/localization/domain/model/language_model.dart';
import 'package:aitek/util/images.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
class AppConstants {
  static const bool demo = true;
  static const String appName = 'Aitek Ltd.';
  static const String slogan = 'Empowering Schools. Empowering Futures.';
  static const String version = '1.0';   /// Flutter SDK 3.38.6
  static const int versionCode = 1;
  static const String currency = "USD";
  static const String chatGptApiKey = 'your ApiKey';
  static const String baseUrl = 'https://peanut.ifxdb.com'; //Set Your api base url Here
  static const String secondBaseUrl = 'https://client-api.contentdatapro.com'; //Set Your api base url Here
  static const String soapBaseUrl = 'https://api-forexcopy.contentdatapro.com/Services/CabinetMicroService.svc'; //Set Your api base url Here
  static const String imageBaseUrl = '$baseUrl/storage';






  static const String loginUri = '/api/ClientCabinetBasic/IsAccountCredentialsCorrect';
  static const String loginTwoUri = '/api/Authentication/RequestMoblieCabinetApiToken';
  static const String getLastFourNumberPhone = '/api/ClientCabinetBasic/GetLastFourNumbersPhone';
  static const String branches = '/api/branches';




  static const String profile = '/api/ClientCabinetBasic/GetAccountInformation';
  static const String getAnalyticSignals = '/clientmobile/GetAnalyticSignals';





  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String tokenTwo = 'tokenTwo';
  static const String deviceToken = 'deviceToken';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String searchAddress = 'search_address';
  static const String localization = 'X-Localization';
  static const String topic = 'notify';
  static const String username = 'username';
  static const String parent = 'Parent';
  static const String studentType = 'Student';
  static const String superAdmin = 'Super Admin';
  static const String sassAdmin = 'SAAS Admin';
  static const String studentPanel = 'student_panel';
  static const String skipOnboard = 'skip-onboard';
  static const String demoModeMessage = 'This Feature is restricted in demo mode.';
  static const String instituteType = 'instituteType';


  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.bangladesh, languageName: 'Bengali', countryCode: 'BD', languageCode: 'bn'),
    LanguageModel(imageUrl: Images.saudi, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];

  static const int limitOfPickedIdentityImageNumber = 2;
  static const double limitOfPickedImageSizeInMB = 2;
  static const double completionArea = 500;

  static final phoneNumberFormat = FilteringTextInputFormatter.digitsOnly;
  static final numberFormat = FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'));

  static Future<void> onOpen(LinkableElement link) async {
    if (!await launchUrl(Uri.parse(link.url))) {
      throw 'Could not launch ${link.url}';
    }
  }

  static Future<void> openUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
  static Future<void> sendEmail(String emailAddress, {String subject = '', String body = ''}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  static final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  static String htmlToPlainText(String htmlContent) {
    final element = html.DocumentFragment.html(htmlContent);
    return element.text ?? '';
  }

  static String timeToAmPm(String time) {
    try {
      final dateTime = DateFormat("hh:mm a").parse(time);
      return DateFormat("hh:mm a").format(dateTime);
    } catch (_) {
      final dateTime = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(dateTime);
    }
  }

  static Color parseHexColor(String? hexColor, {Color fallback = const Color(0xFF6750A4)}) {
    if (hexColor == null || hexColor.isEmpty) return fallback;

    try {
      String value = hexColor.replaceAll('#', '').toUpperCase();
      if (value.length == 6) {
        value = 'FF$value';
      }
      return Color(int.parse(value, radix: 16));
    } catch (e) {
      return fallback;
    }
  }


}
