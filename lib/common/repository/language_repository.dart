
import 'package:mighty_school/localization/domain/model/language_model.dart';
import 'package:mighty_school/util/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages() {
    return AppConstants.languages;
  }
}
