import 'package:get/get.dart';
import 'package:mighty_school/common/widget/set_canonical_url_widget.dart';

GetPage customPage({
  required String name,
  required GetPageBuilder page,
  Object? arguments,
}) {
  return GetPage(
    name: name,
    page: page,
    arguments: arguments,
    middlewares: [CanonicalUrlMiddleware()],
  );
}