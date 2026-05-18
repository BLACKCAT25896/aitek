import 'package:get/get.dart';
import 'package:mighty_school/util/app_constants.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/widgets.dart';

/// Update the canonical link
void setCanonicalUrl(String url) {
  final head = html.document.head!;
  head.querySelectorAll("link[rel='canonical']").forEach((e) => e.remove());
  final canonicalLink = html.LinkElement()
    ..rel = 'canonical'
    ..href = url;
  head.append(canonicalLink);
}

/// Set the <title>
void setDocumentTitle(String title) {
  html.document.title = title;
}

/// Set the meta description
void setMetaDescription(String description) {
  final head = html.document.head!;
  head.querySelectorAll("meta[name='description']").forEach((e) => e.remove());
  final meta = html.MetaElement()
    ..name = 'description'
    ..content = description;
  head.append(meta);
}

/// RouteObserver to update canonical on push/replace
class CanonicalRouteObserver extends NavigatorObserver {
  final String baseUrl;
  CanonicalRouteObserver({required this.baseUrl});

  void _updateSeo(Route route) {
    final path = route.settings.name ?? '';
    setCanonicalUrl('$baseUrl$path');

    if (route.settings.arguments is SeoData) {
      final seo = route.settings.arguments as SeoData;
      setDocumentTitle(seo.title);
      setMetaDescription(seo.description);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _updateSeo(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute != null) _updateSeo(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

/// Optional: SEO Data model
class SeoData {
  final String title;
  final String description;

  SeoData({required this.title, required this.description});
}

/// GetMiddleware to inject SEO tags for GetPages
class CanonicalUrlMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    if (page != null) {
      setCanonicalUrl('${AppConstants.baseUrl}${page.name}');
      if (page.arguments is SeoData) {
        final seo = page.arguments as SeoData;
        setDocumentTitle(seo.title);
        setMetaDescription(seo.description);
      }
    }
    return page;
  }
}
