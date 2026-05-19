
import 'package:aitek/localization/domain/model/language_model.dart';
import 'package:aitek/util/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages() {
    return AppConstants.languages;
  }
}
