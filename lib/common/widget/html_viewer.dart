import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:mighty_school/util/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:universal_html/html.dart' as html;

class HtmlViewer extends StatelessWidget {
  final String? htmlText;
  const HtmlViewer({super.key, required this.htmlText});

  @override
  Widget build(BuildContext context) {

    return htmlText == '@' ? const SizedBox() : HtmlWidget(
      htmlText ?? '',
      textStyle: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
      onTapUrl: (String url) {
        if(GetPlatform.isWeb) {
          html.window.open(url,'_blank');
          return true;
        }else {
          return launchUrlString(url, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}
